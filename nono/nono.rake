require 'fileutils'

namespace :nono do
  desc "Install nono"
  task :install => :ensure_dirs do
    config_dir  = File.expand_path("~/.config")
    current_dir = File.expand_path(File.dirname(__FILE__))
    FileUtils.ln_s(File.join(current_dir, "nono"), config_dir)
  end
end
