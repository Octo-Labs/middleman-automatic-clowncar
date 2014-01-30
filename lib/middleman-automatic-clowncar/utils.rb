module Middleman
  module AutomaticClowncar
    class Utils


      def self.origin_mtime(source_dir,origin)
        origin_path = File.join(source_dir,origin)
        origin_mtime = File.mtime(origin_path).to_s.strip
      end

      def self.stored_timestamp(output_dir,origin)
        path = File.join(output_dir, clowncar_timestamp_path(origin))
        return nil if !File.exist?(path)
        File.open(path).read.strip
      end

      def self.timestamp_current?(source_dir,output_dir,origin)
        origin_mtime(source_dir,origin) == stored_timestamp(output_dir,origin)
      end

      def self.clowncar_dir(origin)
        dirname = File.dirname(origin)
        filename = File.basename(origin,'.*')
        File.join(dirname,filename)
      end

      def self.clowncar_timestamp_path(origin)
        File.join( clowncar_dir(origin), "timestamp.txt" );
      end

      # strip the source_dir and any leading slashes
      def self.naked_origin(source_dir,origin)
        origin.gsub(source_dir + File::SEPARATOR, '')
      end

      def self.full_source_path(source_dir,origin)
        File.join( source_dir, naked_origin(source_dir,origin) )
      end

    end
  end
end
