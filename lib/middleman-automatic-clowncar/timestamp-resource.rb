module Middleman
  module AutomaticClowncar
    class TimestampResource < ::Middleman::Sitemap::Resource
      
      attr_accessor :output

      def initialize(store, path, origin, source_dir)
        @source_dir = source_dir
        @origin = origin
        super(store, path)
      end

      def template?
        false
      end

      def source_file
        @origin
      end

      def render(*args, &block)
        Utils.origin_mtime(@source_dir,@origin)
      end

      # def request_path
      #   @request_path
      # end

      def binary?
        false
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
