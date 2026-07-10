require 'fileutils'
require 'open-uri'

namespace :vim do
  desc "Install custom vim actions"
  task :install => :ensure_dirs do
    clone_and_symlink_repo(repo: "copiousfreetime/vimfiles", target: "~/.config/nvim")
  end

  desc "Install vim itself"
  task :install_vim do
    version = "v0.12.2"
    basename = "nvim-linux-x86_64.tar.gz"
    url = "https://github.com/neovim/neovim-releases/releases/download/#{version}/#{basename}"
    %x[ mkdir -p ~/tmp ]
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
