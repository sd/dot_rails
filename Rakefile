


desc "Run the script/runner for the test app with ARGS"
task :run do
  system "cd test/app && (script/runner \"#{ENV["ARGS"].gsub("\"", "\\\"")}\")"
end

