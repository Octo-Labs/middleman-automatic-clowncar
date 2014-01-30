module Middleman
  module AutomaticClowncar
    class TimestampResource < ::Middleman::Sitemap::Resource
      
      attr_accessor :output

      def initialize(store, path, timestamp)
        @timestamp = timestamp

        super(store, path)
      end

      def template?
        true
      end

      def render(*args, &block)
        @timestamp
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
