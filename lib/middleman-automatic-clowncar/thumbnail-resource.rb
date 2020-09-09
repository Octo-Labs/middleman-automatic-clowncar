module Middleman
  module AutomaticClowncar
    class ThumbnailResource < ::Middleman::Sitemap::Resource

      require 'mini_magick'

      attr_accessor :output

      def initialize(store, path, dimensions, origin, root_path, build_dir, source_dir)
        @dimensions = dimensions
        @origin = origin
        @root_path = root_path
        @build_dir = build_dir
        @source_dir = source_dir
        super(store, path, source_dir.to_s)
      end

      def template?
        false
      end

      def source_file
        nil
      end

      def render(*args, &block)
        output_dir = File.join(@root_path,@build_dir)
        dest_path = File.join(output_dir,@path)
        img = nil
        if Utils.timestamp_current?(@source_dir,@build_dir,@origin) && File.exist?(dest_path)
          img = MiniMagick::Image.open(dest_path)
        else
          img = MiniMagick::Image.open(@origin)
          img.resize(@dimensions) unless @dimensions.blank?
        end
        img.to_blob
      end

      def binary?
        false
      end

      def raw_data
        {}
      end

      def ignored?
        false
      end

    end
  end
end

