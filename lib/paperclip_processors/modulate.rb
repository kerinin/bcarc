module Paperclip
  class Modulate < Paperclip::Processor

    attr_accessor :file, :brightness, :saturation, :hue
    
    def transformation
      trans = "-modulate #{@brightness},#{@saturation},#{@hue}"
    end    
    
    def convert(src, dst)
      command = "\"#{ File.expand_path( src.path ) }[0]\" #{ transformation } \"#{ File.expand_path(dst.path) }\"\n" 
      Paperclip.run('convert',command)
      dst
    end
        
    def initialize(file, options = {}, *args)
      @file = file
      
      @brightness = options[:brightness]   ||= 100
      @saturation = options[:saturation]   ||= 100
      @hue        = options[:hue]          ||= 100
    end
  
    def make( *args )
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
        
      return convert( @file, dst )
    end
  end
end
