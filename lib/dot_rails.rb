class DotRails
  def self.activate
    Object.const_set("RAILS_APP", DotRails.guess_app_name) unless Object.const_defined? "RAILS_APP"
    Object.const_set("DOT_RAILS_PATH", DotRails.guess_dot_rails_path) unless Object.const_defined? "DOT_RAILS_PATH"
    RAILS_DEFAULT_LOGGER.debug "DotRails activated for #{RAILS_APP} at #{DOT_RAILS_PATH}"
  end
  
  def self.guess_app_name
    File.basename(File.expand_path(RAILS_ROOT))
  end
  
  def self.guess_dot_rails_path
    File.expand_path "~/.rails"
  end
end

