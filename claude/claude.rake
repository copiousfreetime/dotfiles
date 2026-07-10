require 'fileutils'

namespace :claude do
  desc "Install custom claude files"
  task :install => :ensure_dirs do
    clone_and_symlink_repo(repo: "copiousfreetime/claudefiles", target: "~/.claude")
  end

end
