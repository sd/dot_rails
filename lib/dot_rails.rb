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
    for possible_path in ["$DOT_RAILS_PATH", "~/.rails", "$HOME/.rails", ".."]
      possible_path = File.expand_path(possible_path)
      matches = [
        "database.yml", "pre-environment.rb", 
        "environment.rb", "#{RAILS_ENV}.rb"
      ].select {|name| 
        File.exist? File.join(possible_path, "#{RAILS_APP}-#{name}")
      }
      return possible_path if matches.any?
    end
  end
  
  def self.database_file
    File.join(DOT_RAILS_PATH, "#{RAILS_APP}-database.yml")
  end

  def self.pre_environment_file
    File.join(DOT_RAILS_PATH, "#{RAILS_APP}-pre-environment.rb")
  end

  def self.post_environment_file
    File.join(DOT_RAILS_PATH, "#{RAILS_APP}-environment.rb")
  end
  
  def self.environment_file
    File.join(DOT_RAILS_PATH, "#{RAILS_APP}-#{RAILS_ENV}.rb")
  end
end

unless DotRails.loaded?
  DotRails.prepare
  
  if DOT_RAILS_PATH
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
      
        if File.exist? DotRails.environment_file
          Rails::Configuration.send(:define_method, :environment_path) {DotRails.environment_file}
          @environment_loaded = false if @environment_loaded
          load_environment_without_dot_rails
        end
        Rails::Configuration.send(:define_method, :environment_path) {original_path}
      end
      alias_method :load_environment_without_dot_rails, :load_environment
      alias_method :load_environment, :load_environment_with_dot_rails
    
      def process_with_dot_rails(*args)
        if File.exist? DotRails.pre_environment_file
          load DotRails.pre_environment_file
        end

        process_without_dot_rails(*args)

        if File.exist? DotRails.post_environment_file
          load DotRails.post_environment_file
        end
      end
      alias_method :process_without_dot_rails, :process
      alias_method :process, :process_with_dot_rails
    end
  end
  
  DotRails.loaded!
end

