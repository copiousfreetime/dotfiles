require 'fileutils'

namespace :base16 do
  desc "Install base16"
  task :install do
    config_dir  = File.expand_path("~/.config")
    current_dir = File.dirname(__FILE__).expand_path
    FileUtils.ln_s(File.join(current_dir, "base16-shell"), config_dir)
  end
end
