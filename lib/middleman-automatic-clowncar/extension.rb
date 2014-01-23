require 'middleman-core'

require 'middleman-automatic-clowncar/thumbnail-generator'

require 'fastimage'

module Middleman
  module AutomaticClowncar
    class Extension < Middleman::Extension
      
      SVG_TEMPLATE = "<svg viewBox='0 0 ::width:: ::height::' preserveAspectRatio='xMidYMid meet' xmlns='http://www.w3.org/2000/svg'><style>svg{background-size:100% 100%;background-repeat:no-repeat;}::media_queries::</style></svg>"
      
      option :sizes, {}, "The sizes of thumbnails to generate"
      option :namespace_directory, ["**"], "The directories inside of images that should be clowncared."
      option :filetypes, [:jpg, :jpeg, :png], "The types of files to use for automatic clowncaring."

      cattr_accessor :options_hash

      def initialize(app, options_hash={}, &block)
        super
        options_hash[:filetypes] ||= [:jpg, :jpeg, :png]
        Extension.options_hash = options_hash
        # Clowncar bits
        require 'uri'
        require 'pathname'
        @ready = false

        #Thumbnailer
        app.after_configuration do

          #stash the source images dir in options for the Rack middleware
          Extension.options_hash[:images_source_dir] = File.join(source_dir, images_dir)
          Extension.options_hash[:source_dir] = source_dir

          sizes = Extension.options_hash[:sizes]
          namespace = Extension.options_hash[:namespace_directory].join(',')

          dir = Pathname.new(File.join(source_dir, images_dir))
          glob = "#{dir}/{#{namespace}}/*.{#{Extension.options_hash[:filetypes].join(',')}}"
          files = Dir[glob]

          # don't build the files until after build
          after_build do |builder|
            puts "Generating automatic clowncar images"
            files.each do |file|
              path = file.gsub(source_dir, '')
              specs = ThumbnailGenerator.specs(path, sizes, source_dir)
              ThumbnailGenerator.generate(source_dir, File.join(root, build_dir), path, specs)
            end
          end

          sitemap.register_resource_list_manipulator(:thumbnailer, SitemapExtension.new(self), true)

          app.use Rack, Extension.options_hash
        end
      end
      
      def after_configuration
        @ready = true
      end

      def is_relative_url?(path)
        begin
          uri = URI(path)
        rescue URI::InvalidURIError
          # Nothing we can do with it, it's not really a URI
          return false
        end

        !uri.host
      end

      def get_image_path(name, path, is_relative, fallback_host)
        #puts "@@@@@@@ calling get_image_path for #{path}"
        begin
          uri = URI(path)
        rescue URI::InvalidURIError
          # Nothing we can do with it, it's not really a URI
          return path
        end

        if uri.host
          path
        else
          
          svg_path = File.join(File.dirname(name),File.basename(name,".*"), path)

          if is_relative
            url = app.asset_path(:images, svg_path)

            if fallback_host &&is_relative_url?(url)
              File.join(fallback_host, url)
            else
              url
            end
          else
            svg_path
          end
        end
      end



      def generate_media_queries(name, sizes, is_relative, fallback_host)
        output = []

        if sizes.keys.length === 1
          return "svg{background-image:url(#{get_image_path(name, sizes[sizes.keys.first], is_relative, fallback_host)});}"
        end

        previous_key = nil
        sizes.keys.sort.each_with_index do |key, i|
          line = ["@media screen and "]

          if i == 0
            line << "(max-width:#{key}px)"
          elsif i == (sizes.keys.length - 1)
            line << "(min-width:#{previous_key+1}px)"
          else
            line << "(min-width:#{previous_key+1}px) and (max-width:#{key}px)"
          end

          line << "{svg{background-image:url(#{get_image_path(name, sizes[key], is_relative, fallback_host)});}}"

          output << line.join("")
          previous_key = key
        end

        output.join("")
      end

      def get_physical_image_size(name)
        main_path = File.join(app.images_dir,name)
        main_abs_path = File.join(app.source_dir,main_path)
        FastImage.size(main_abs_path, :raise_on_failure => true)
      end

      def get_image_sizes(name, options)
        #puts "getting images sizes for #{name}"

        main_path = File.join(app.images_dir,name)
        main_abs_path = File.join(app.source_dir,main_path)

        extname = File.extname(name)
        basename = File.basename(name, ".*")

        return {} unless File.exist? main_abs_path

        width, height = ::FastImage.size(main_abs_path, :raise_on_failure => true)

        
        sizes = {}
        Extension.options_hash[:sizes].each_pair do |sname,swidth|
          next if swidth > width
          sizes[swidth] = "#{basename}-#{sname}#{extname}"
        end

        if options[:include_original]
          sizes[width] = "../#{basename}#{extname}"
        end

        #puts "-"*30
        #puts [sizes, width, height]
        [sizes, width, height]
      end


      def generate_svg(name, is_relative, options)
        #puts "name for generate_svg = #{name}"
        #puts "options for generate_svg = #{options}"
        sizes, width, height = get_image_sizes(name, options)
        
        fallback_host = false
        if is_relative 
          test_path = app.asset_path(:images, "#{name}.svg")
          if is_relative_url?(test_path)
            if options.has_key?(:host)
              fallback_host = options[:host]
            else
              warn "WARNING: Inline clowncar images require absolute paths. Please set a :host value"
            end
          end
        end

        media_queries = generate_media_queries(name, sizes, is_relative, fallback_host)

        xml = SVG_TEMPLATE.dup
        xml.sub!("::media_queries::", media_queries)
        xml.sub!("::width::", width.to_s)
        xml.sub!("::height::", height.to_s)
        xml
      end

      def generate_clowncar(name, options={})
        Extension.svg_files_to_generate << [name, options]
      end

      



      
      helpers do
        def automatic_clowncar_tag(name, options={})
          internal = ""

          if options[:fallback]
            
            fallback = File.basename thumbnail_url(name,:small)
            fallback_path = extensions[:automatic_clowncar].get_image_path(name, fallback, true, false)
            internal = %{<!--[if lte IE 8]><img src="#{fallback_path}"><![endif]-->}
          end

          object_style = ""
          if options.has_key?(:prevent_upscaling) && options[:prevent_upscaling]
            if options.has_key?(:include_original) && options[:include_original]
              width, height = extensions[:automatic_clowncar].get_physical_image_size(name)
            else
              width = extensions[:automatic_clowncar].options.sizes.map{|k,v| v }.sort.last
            end
            object_style = "max-width:#{width}px;"
          end

          if options.has_key?(:inline) && (options[:inline] === false)
            url = asset_path(:images, "#{name}.svg")
            %Q{<object type="image/svg+xml" style="#{object_style}" data="#{url}">#{internal}</object>}
          else
            data = extensions[:automatic_clowncar].generate_svg(name, true, options)
            %Q{<object type="image/svg+xml" style="#{object_style}" data="data:image/svg+xml,#{::URI.escape(data)}">#{internal}</object>}
          end
        end

        def thumbnail_specs(image, name)
          sizes = Extension.options_hash[:sizes]
          ThumbnailGenerator.specs(image, sizes, File.join(source_dir,images_dir))
        end

        def thumbnail_url(image, name, options = {})
          include_images_dir = options.delete :include_images_dir

          url = thumbnail_specs(image, name)[name][:name]
          url = File.join(images_dir, url) if include_images_dir

          url
        end

      end # helpers

      class SitemapExtension
        def initialize(app)
          @app = app
        end

        # Add sitemap resource for every image in the sprockets load path
        def manipulate_resource_list(resources)

          images_dir_abs = File.join(@app.source_dir, @app.images_dir)

          images_dir = @app.images_dir

          options = Extension.options_hash
          sizes = options[:sizes]
          namespace = options[:namespace_directory].join(',')
          glob = "#{images_dir_abs}/{#{namespace}}/*.{#{Extension.options_hash[:filetypes].join(',')}}"
          files = Dir[glob]
          resource_list = files.map do |file|
            path = file.gsub(@app.source_dir + File::SEPARATOR, '')
            specs = ::Middleman::AutomaticClowncar::ThumbnailGenerator.specs(path, sizes,@app.source_dir)
            specs.map do |name, spec|
              resource = nil
              dest_path = File.join(@app.root_path,@app.build_dir, spec[:name])
              source = File.exists?(dest_path) ? dest_path : file
              resource = Middleman::Sitemap::Resource.new(@app.sitemap, spec[:name], source) unless name == :original
            end
          end.flatten.reject {|resource| resource.nil? }

          resources + resource_list
        end
      end # SitemapExtension


      # Rack middleware to convert images on the fly
      class Rack
        require 'mini_magick'
        # Init
        # @param [Class] app
        # @param [Hash] options
        def initialize(app, options={})
          #puts "iniit for Raaaaaaaaaaaaaaaaaaaaaaaaaack"
          @app = app
          @options = options

          files = Dir["#{options[:images_source_dir]}/**/*.{#{options[:filetypes].join(',')}}"]
          @original_map = ThumbnailGenerator.original_map_for_files(files, options[:sizes],options[:source_dir])
          #puts @original_map
        end

        # Rack interface
        # @param [Rack::Environmemt] env
        # @return [Array]
        def call(env)
          status, headers, response = @app.call(env)

          path = env["PATH_INFO"]

          path_on_disk = File.join(@options[:source_dir], path)
          
          #puts "calling!!!!!!"
          #puts "path = #{path}"
          #puts "original_map[path] = #{@original_map[path.sub('/','')]}"
          #TODO: caching
          if original_specs = @original_map[path.sub('/','')]
            original_file = original_specs[:original]
            spec = original_specs[:spec]
            if spec.has_key? :dimensions
              image = ::MiniMagick::Image.open(File.join(@options[:source_dir],original_file))
              blob = nil
              image.resize spec[:dimensions]
              blob = image.to_blob
              unless blob.nil?
                status = 200
                headers["Content-Length"] = ::Rack::Utils.bytesize(blob).to_s
                headers["Content-Type"] = image.mime_type
                response = [blob]
              end
            end
          end

          [status, headers, response]
        end
      end



    end # Extension
  end # AutomaticClowncar
end # Middleman

