class DotRails
  def self.loaded?
    @loaded
  end
  
  def self.loaded!
    @loaded = true
  end
  
  def self.prepare
    Object.const_set("RAILS_APP", DotRails.guess_app_name) unless Object.const_defined? "RAILS_APP"
    Object.const_set("DOT_RAILS_PATH", DotRails.guess_dot_rails_path) unless Object.const_defined? "DOT_RAILS_PATH"
  end
  
  def self.guess_app_name
    File.basename(File.expand_path(RAILS_ROOT))
  end
  
  def self.guess_dot_rails_path
    File.expand_path "~/.rails"
  end
  
  def self.database_file
    File.join(DOT_RAILS_PATH, "#{RAILS_APP}-database.yml")
  end
  
  def self.environment_files
    [
      File.join(DOT_RAILS_PATH, "#{RAILS_APP}-environment.rb"),
      File.join(DOT_RAILS_PATH, "#{RAILS_APP}-#{RAILS_ENV}.rb"),
    ]
  end
  
  def self.override_database_configuration(initializer)
  end
end

unless DotRails.loaded?
  DotRails.prepare
  
  class Rails::Initializer
    def initialize_database_with_dot_rails
      if File.exist?(DotRails.database_file)
        configuration.database_configuration_file = DotRails.database_file
      end
      initialize_database_without_dot_rails
    end
    alias_method :initialize_database_without_dot_rails, :initialize_database
    alias_method :initialize_database, :initialize_database_with_dot_rails

    def load_environment_with_dot_rails
      load_environment_without_dot_rails
      original_path = configuration.environment_path
      
      for path in DotRails.environment_files.select {|file| File.exist? file}
        Rails::Configuration.send(:define_method, :environment_path) {path}
        @environment_loaded = false if @environment_loaded
        load_environment_without_dot_rails
      end
      Rails::Configuration.send(:define_method, :environment_path) {original_path}
    end
    alias_method :load_environment_without_dot_rails, :load_environment
    alias_method :load_environment, :load_environment_with_dot_rails
  end
  
  DotRails.loaded!
end

