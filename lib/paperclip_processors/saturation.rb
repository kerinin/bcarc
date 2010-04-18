module Paperclip
  class Saturation < Paperclip::Thumbnail

    def transformation
      trans = "-saturation #{@saturation.to_s}"
    end    
    
    def convert(dst)
      command = "\"#{ File.expand_path( @thumbnail.path ) }[0]\"\n#{ transformation }\n\"#{ File.expand_path(dst.path) }\"\n" 
      Paperclip.run('convert',command)
      dst
    end
        
    def initialize(file, options = {}, attachment = nil)
      super file, options, attachment
      
      @options = options
      
      # defaults to desaturate
      @saturation = options['saturation'].nil? ? 0.0 : options['saturation'].to_f
    end
  
    def make
      @thumbnail = super

      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode    
      
      return convert( dst )
    end
  end
end
