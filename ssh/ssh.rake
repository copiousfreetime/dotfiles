require 'fileutils'

namespace :ssh do
  desc "Install custom ssh"
  task :install do
    config_dir  = File.expand_path("~/.ssh")
    current_dir = File.expand_path(File.dirname(__FILE__))

    dest_file = File.join(config_dir, "rc")
    src_file = File.join(current_dir, "rc")

    FileUtils.mkdir_p(config_dir)
    FileUtils.chmod(0700, config_dir)
    FileUtils.cp(src_file, dest_file)
    FileUtils.chmod(0700, dest_file)
  end
end
