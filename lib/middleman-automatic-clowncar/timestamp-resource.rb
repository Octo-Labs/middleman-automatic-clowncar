module Middleman
  module AutomaticClowncar
    class TimestampResource < ::Middleman::Sitemap::Resource
      
      attr_accessor :output

      def initialize(store, path, origin, source_dir)
        puts "====================================================="
        puts store
        puts path
        puts origin
        puts source_dir
        puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        @source_dir = source_dir
        @origin = origin
        super(store, path, source_dir.to_s)
        puts "@metadata = #{@metadata}"
      end

      def template?
        false
      end

      def render(*args, &block)
        Utils.origin_mtime(@source_dir,@origin)
      end

      def source_file
        nil
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

      #def metadata
        #@local_metadata.dup
      #end


    end
  end
end
