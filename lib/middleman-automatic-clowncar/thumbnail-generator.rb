require 'RMagick'

module Middleman
  module AutomaticClowncar
  #actually creates the thumbnail names
  class ThumbnailGenerator
    class << self

      def specs(origin, dimensions)
        dir = File.dirname(origin)
        filename = File.basename(origin,'.*')
        ext = File.extname(origin)

        dir = File.join(dir,filename)

        ret = {original: {name: origin}}

        dimensions.each do |name, dimension|
          location = File.join(dir,"#{filename}-#{name}#{ext}")
          ret[name] = {name:location , dimensions: dimension}
        end

        ret
      end

      def generate(source_dir, output_dir, origin, specs)
        image = ::Magick::Image.read(File.join(source_dir, origin)).first
        specs.each do |name, spec|
          if spec.has_key? :dimensions then
            image.change_geometry(spec[:dimensions]) do |cols, rows, img|
              img = img.resize(cols, rows)
              img = img.sharpen(0.5, 0.5)
              img.write File.join(output_dir, spec[:name])
            end
          end
        end
      end

      def original_map_for_files(files, specs)
        map = files.inject({}) do |memo, file|
          generated_specs = self.specs(file, specs)
          generated_specs.each do |name, spec|
            memo[spec[:name]] = {:original => generated_specs[:original][:name], :spec => spec}
          end
          memo
        end
      end
    end
  end
  end
end
