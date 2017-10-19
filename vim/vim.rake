require 'fileutils'

namespace :vim do
  desc "Install custom vim actions"
  task :install do
    parent_repo = File.expand_path("~/repos/github.com/copiousfreetime")
    repo_dir    = File.join(parent_repo, "vimfiles")
    config_dir  = File.expand_path("~/.config")
    nvim_config = File.join(config_dir, "nvim")

    FileUtils.mkdir_p(parent_repo)
    FileUtils.mkdir_p(config_dir)

    %x[ git clone git@github.com:copiousfreetime/vimfiles.git #{repo_dir} ]
    %x[ ln -s #{repo_dir} #{nvim_config} ]
  end

end
