unless Object.const_defined? "DotRails"
  STDERR.puts "The DotRails plugin requires you to add the following lines"
  STDERR.puts "to your config/boot.rb file:"
  STDERR.puts "require \"\#{RAILS_ROOT}/vendor/plugins/dot_rails/lib/dot_rails\""
  STDERR.puts "*BEFORE* the Rails::Initializer.run line"
  STDERR.puts ""
  STDERR.puts "JUST SO YOU KNOW, THAT MEANS DOT RAILS IS NOT ACTIVE AT THIS TIME!!! KTXBAI"
  STDERR.puts ""
end
