module Paperclip
  class Modulate < Paperclip::Thumbnail

    attr_accessor :brightness, :saturation, :hue
    
    def transformation
      trans = "-modulate #{@brightness},#{@saturation},#{@hue}"
    end    
    
    def convert(src, dst)
      command = "\"#{ File.expand_path( src.path ) }[0]\"\n#{ transformation }\n\"#{ File.expand_path(dst.path) }\"\n" 
      Paperclip.run('convert',command)
      dst
    end
        
    def initialize(file, options = {}, *args)
      super( file, options, *args )
    
      @brightness = options[:brightness]   ||= 100
      @saturation = options[:saturation]   ||= 100
      @hue        = options[:hue]          ||= 100
    end
  
    def make( *args )
      if (@brightness != 100) || (@saturation != 100) || (@hue != 100)
        dst = Tempfile.new([@basename, @format].compact.join("."))
        dst.binmode    
        
        return convert( super( *args ), dst )
      else
        super *args
      end
    end
  end
end
