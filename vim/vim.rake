require 'fileutils'
require 'open-uri'

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

  desc "Install vim itself"
  task :install_vim do
    version = "v0.9.5"
    basename = "nvim-linux64.tar.gz"
    url = "https://github.com/neovim/neovim/releases/download/#{version}/#{basename}"
    dest = File.expand_path("~/tmp/#{basename}")

    # download the file into a directory, unpack it, and then move the files
    # into the right place
    File.open(dest, "wb") do |out|
      URI.open(url, "rb") do |file|
        out.write(file.read)
      end
    end

    %x[ mkdir -p ~/.opt ]
    %x[ tar -xvf #{dest} -C ~/.opt/]
  end
end
