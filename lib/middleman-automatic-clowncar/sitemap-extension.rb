module Middleman
  module AutomaticClowncar
    class SitemapExtension

      def initialize(app)
        @app = app
      end

      # Add sitemap resource for every image in the sprockets load path
      def manipulate_resource_list(resources)

        options = Extension.options_hash
        sizes = options[:sizes]
        namespace = options[:namespace_directory].join(',')
        glob = "#{@app.source_dir}/{#{namespace}}/*.{#{Extension.options_hash[:filetypes].join(',')}}"
        files = Dir[glob]
        resource_list = []
        files.each do |file|
          path = Utils.naked_origin(@app.source_dir,file)
          specs = ::Middleman::AutomaticClowncar::ThumbnailGenerator.specs(path, sizes,@app.source_dir)
          specs.each_pair do |name, spec|
            next if name == :original
            dest_path = File.join(@app.root_path,@app.build_dir, spec[:name])
            source = File.exists?(dest_path) ? dest_path : file
            resource_list << Middleman::AutomaticClowncar::ThumbnailResource.new(@app.sitemap,spec[:name],spec[:dimensions],file,@app.root_path,@app.build_dir,@app.source_dir)
            #resource_list << Middleman::Sitemap::Resource.new(@app.sitemap, spec[:name], source) unless name == :original
          end
          fname = specs.first[1][:name]
          timestampDir = File.join(File.dirname(fname),File.basename(fname,'.*'))
          timestampPath = File.join(timestampDir,'timestamp.txt')
          resource_list << Middleman::AutomaticClowncar::TimestampResource.new(@app.sitemap, timestampPath, path, @app.source_dir)
        end
        resource_list.flatten.reject {|resource| resource.nil? }

        resources + resource_list
      end

    end # SitemapExtension
  end
end
