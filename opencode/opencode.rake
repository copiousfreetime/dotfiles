require 'fileutils'

namespace :opencode do
  desc 'Install custom opencode files'
  task :install => :ensure_dirs do
    clone_and_symlink_repo(repo: "copiousfreetime/opencode-files", target: "~/.config/opencode")
  end
end
