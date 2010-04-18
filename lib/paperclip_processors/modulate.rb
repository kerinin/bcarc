module Paperclip
  class Modulate < Paperclip::Thumbnail

    def transformation
      trans = "-modulate #{@brightness},#{@saturation},#{@hue}"
    end    
    
    def convert(dst)
      command = "\"#{ File.expand_path( @thumbnail.path ) }[0]\"\n#{ transformation }\n\"#{ File.expand_path(dst.path) }\"\n" 
      Paperclip.run('convert',command)
      dst
    end
        
    def initialize(file, options = {}, attachment = nil)
      super file, options, attachment
      
      @options = options
      
      @brightness = options[:brightness]   ||= 100
      @saturation = options[:saturation]   ||= 100
      @hue        = options[:hue]          ||= 100
    end
  
    def make
      @thumbnail = super
      
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode    
      
      return convert( dst )
    end
  end
end
