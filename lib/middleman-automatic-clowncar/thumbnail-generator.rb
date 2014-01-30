
module Middleman
  module AutomaticClowncar
  #actually creates the thumbnail names
  class ThumbnailGenerator
    class << self

      def specs(origin, dimensions, source_dir)
        #puts "origin = #{origin}"
        #puts "source_dir = #{source_dir}"
        origin = origin.gsub(source_dir + File::SEPARATOR, '')
        width, height = FastImage.size(File.join(source_dir,origin))

        dir = File.dirname(origin)
        filename = File.basename(origin,'.*')
        ext = File.extname(origin)

        dir = File.join(dir,filename)

        ret = {original: {name: origin}}

        dimensions.each do |name, dimension|
          next if dimension > width
          location = File.join(dir,"#{filename}-#{name}#{ext}")
          ret[name] = {name:location , dimensions: dimension}
        end
        ret
      end

      def generate(source_dir, output_dir, origin, specs)

        fname = specs.first[1][:name]
        timestampDir = File.join(File.dirname(fname),File.basename(fname,'.*'))
        timestampPath = File.join(output_dir,timestampDir,'timestamp.txt')
        puts "timestampPath = #{timestampPath}"

        image = nil
        origin_path = File.join(source_dir,origin)
        origin_mtime = File.mtime(origin_path)

        #puts "origin_mtime = #{origin_mtime.to_s.strip}"
        #puts "timestamp = #{File.open(timestampPath).open.read}"
        #if File.exist?(timestampPath) && File.open(timestampPath).open.read.squish == origin_mtime.to_s.squish
        #  return
        #end

        specs.each do |name, spec|
          if spec.has_key? :dimensions then
            dest_path = File.join(output_dir,spec[:name])
            dest_dir = File.dirname(dest_path)
            FileUtils.mkdir_p dest_dir # if it exists, nothing happens
            

            if origin_mtime != File.mtime(dest_path)
              puts "Generating automatic clowncar for #{spec[:name]}"
              image = MiniMagick::Image.open(origin_path)
              image.resize spec[:dimensions]
              image.write dest_path
              #image.change_geometry(spec[:dimensions]) do |cols, rows, img|
              #  img = img.resize(cols, rows)
              #  img = img.sharpen(0.5, 0.5)
              #  img.write File.join(dest_path)
              #end
              File.utime(origin_mtime, origin_mtime, dest_path)
            end
          end
        end
        
        #File.open(timestampPath, 'w') {|f| f.write(origin_mtime) }
        
      end

      def original_map_for_files(files, specs, source_dir)
        map = files.inject({}) do |memo, file|
          generated_specs = self.specs(file, specs, source_dir)
          generated_specs.each do |name, spec|
            memo[spec[:name]] = {:original => generated_specs[:original][:name], :spec => spec}
          end
          memo
        end
        # puts map
        map
      end
    end
  end
  end
end
