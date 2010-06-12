require "set"

class RequireParanoia < RuntimeError; end

module Kernel
  
  alias_method :enabled_require, :require
  
  def disabled_require(arg)
    without_ext = arg.sub /(\.rb$)|(\.bundle$)/, ""
    files = %w[.rb .bundle].collect{ |ext| without_ext + ext }
    if ($".to_set & files.to_set).empty?
      raise RequireParanoia, "trying to load file -- #{arg}"
    else
      true
    end
  end
  
  def self.disable_require!
    class_eval{ alias_method :require, :disabled_require }
    
    if block_given?
      begin
        yield
      rescue Exception => e
        raise
      ensure
        enable_require!
      end
    end
    
  end
  
  def self.enable_require!
    class_eval{ alias_method :require, :enabled_require }
  end
  
end