
module Middleman
  module AutomaticClowncar
  #actually creates the thumbnail names
  class ThumbnailGenerator
    class << self

      def specs(origin, dimensions, source_dir)
        #puts "origin = #{origin}"
        #puts "source_dir = #{source_dir}"
        origin = Utils.naked_origin(source_dir,origin) # just in case
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
    
    
    end
  end
  end
end
