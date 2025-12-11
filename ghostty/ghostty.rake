require 'fileutils'

namespace :ghostty do
  desc "Install ghostty config"
  task :install do
    config_dir  = File.expand_path("~/.config")
    current_dir = File.expand_path(File.dirname(__FILE__))
    FileUtils.ln_s(current_dir, config_dir)
  end
end
