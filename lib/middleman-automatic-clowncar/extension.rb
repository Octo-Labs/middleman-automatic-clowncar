require 'middleman-core'

require 'middleman-automatic-clowncar/thumbnail-generator'
require 'middleman-automatic-clowncar/timestamp-resource'
require 'middleman-automatic-clowncar/thumbnail-resource'
require 'middleman-automatic-clowncar/sitemap-extension'
require 'middleman-automatic-clowncar/utils'

require 'fastimage'

module Middleman
  module AutomaticClowncar
    class Extension < Middleman::Extension

      SVG_TEMPLATE = "<svg viewBox='0 0 ::width:: ::height::' preserveAspectRatio='xMidYMid meet' xmlns='http://www.w3.org/2000/svg'><style>svg{background-size:100% 100%;background-repeat:no-repeat;}::media_queries::</style></svg>"

      option :sizes, {}, "The sizes of thumbnails to generate"
      option :namespace_directory, ["**"], "The directories that should be clowncared. (Outside of the sprockets images dir.)"
      option :filetypes, [:jpg, :jpeg, :png], "The types of files to use for automatic clowncaring."
      option :include_originals, false, "Always include original images. (Or not.)"
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
          Extension.options_hash[:source_dir] = app.source_dir

          sizes = Extension.options_hash[:sizes]
          namespace = Extension.options_hash[:namespace_directory].join(',')

          dir = Pathname.new(app.source_dir)
          glob = "#{dir}/{#{namespace}}/*.{#{Extension.options_hash[:filetypes].join(',')}}"
          files = Dir[glob]
        end
      end

      def manipulate_resource_list(resources)
        SitemapExtension.new(self).manipulate_resource_list(resources)
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
        #puts "@@@@@@@ calling get_image_path for name:#{name} path:#{path}, is_relative:#{is_relative}, fallback_host:#{fallback_host}"
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
            # TODO : Previously the images_dir could be configured. Now it seems to be hard coded by middleman?
            images_dir = 'images' # app.images_dir
            url = url.sub("/#{images_dir}/",'/')
            if fallback_host && is_relative_url?(url)
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
        main_abs_path = File.join(app.source_dir,name)
        FastImage.size(main_abs_path, :raise_on_failure => true)
      end

      def get_image_sizes(name, options)
        #puts "getting images sizes for #{name}"

        main_abs_path = File.join(app.source_dir,name)

        extname = File.extname(name)
        basename = File.basename(name, ".*")

        return {} unless File.exist? main_abs_path

        width, height = ::FastImage.size(main_abs_path, :raise_on_failure => true)


        sizes = {}
        Extension.options_hash[:sizes].each_pair do |sname,swidth|
          next if swidth > width
          sizes[swidth] = "#{basename}-#{sname}#{extname}"
        end

        if options[:include_original] || Extension.options_hash[:include_originals]
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
            elsif app.config[:asset_host]
              fallback_host = app.config[:asset_host]
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

          width, height = extensions[:automatic_clowncar].get_physical_image_size(name)
          object_style = ""
          if options.has_key?(:prevent_upscaling) && options[:prevent_upscaling]
            #if options.has_key?(:include_original) && options[:include_original]
            #else
            #  width = extensions[:automatic_clowncar].options.sizes.map{|k,v| v }.sort.last
            #end

            object_style = "max-width:#{width}px;"
          end

          if options.has_key?(:inline) && (options[:inline] === false)
            url = asset_path(:images, "#{name}.svg")
            %Q{<object type="image/svg+xml" style="#{object_style}" data-aspect-ratio="#{width.to_f/height.to_f}" data="#{url}">#{internal}</object>}
          else
            data = extensions[:automatic_clowncar].generate_svg(name, true, options)
            %Q{<object type="image/svg+xml" style="#{object_style}" data-aspect-ratio="#{width.to_f/height.to_f}" data="data:image/svg+xml,#{::URI.escape(data)}">#{internal}</object>}
          end
        end

        def thumbnail_specs(image, name)
          sizes = Extension.options_hash[:sizes]
          ThumbnailGenerator.specs(image, sizes, app.source_dir)
        end

        def thumbnail_url(image, name, options = {})
          include_images_dir = options.delete :include_images_dir

          url = thumbnail_specs(image, name)[name][:name]
          url = File.join(url) if include_images_dir

          url
        end

      end # helpers




    end # Extension
  end # AutomaticClowncar
end # Middleman

