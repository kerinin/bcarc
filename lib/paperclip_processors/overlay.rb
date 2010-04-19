module Paperclip
  class Overlay < Paperclip::Processor

    attr_accessor :file, :overlay
    
    def transformation
      trans = "\"#{File.expand_path(@overlay.path)}\" "
      trans += "-resize #{@size} " unless @size.nil?
      trans += "-composite"
      trans
    end    
    
    def convert(src, dst)
      command = "\"#{ File.expand_path( src.path ) }[0]\"\n#{ transformation }\n\"#{ File.expand_path(dst.path) }\"\n" 
      Paperclip.run('convert',command)
      dst
    end
        
    def initialize(file, options = {}, *args)
      @file = file
      
      @overlay = File.new(options[:overlay])
      @size = options[:overlay_size]
    end
  
    def make( *args )
      if File.exists?(@overlay)
        dst = Tempfile.new([@basename, @format].compact.join("."))
        dst.binmode
          
        return convert( @file, dst )
      else
        return @file
      end
    end
  end
end
