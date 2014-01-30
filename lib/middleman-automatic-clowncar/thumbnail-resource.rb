module Middleman
  module AutomaticClowncar
    class ThumbnailResource < ::Middleman::Sitemap::Resource
      
      attr_accessor :output

      def initialize(store, path, origin, root_path, build_dir, source_dir)
        @origin = origin
        @root_path = root_path
        @build_dir = build_dir
        @source_dir = source_dir
        super(store, path)
      end

      def template?
        false
      end

      def source_file
        output_dir = File.join(@root_path,@build_dir)
        dest_path = File.join(output_dir,@path)
        source_path = File.join(@root_path,@source_dir)
        if Utils.timestamp_current?(@source_dir,@build_dir,@origin) && File.exist?(dest_path)
          File.join(@build_dir,@path)
        else
          @origin
        end
      end

      def render(*args, &block)
        puts "calling render!!!!!!!"
        return "test"
        output_dir = File.join(@root_path,@build_dir)
        dest_path = File.join(output_dir,@path)
        source_path = File.join(@root_path,@source_dir,@origin)
        img = nil
        if Utils.timestamp_current?(@source_dir,@build_dir,origin) && File.exist?(dest_path)
          img = MiniMagick::Image.open(dest_path)
        else
          img = MiniMagick::Image.open(source_path)
        end
        img.to_blob
      end

      # def request_path
      #   @request_path
      # end

      def binary?
        true
      end

      def raw_data
        {}
      end

      def ignored?
        false
      end

      def metadata
        @local_metadata.dup
      end

    end
  end
end

