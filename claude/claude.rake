require 'fileutils'

namespace :claude do
  desc "Install custom claude files"
  task :install do
    parent_repo   = File.expand_path("~/repos/github.com/copiousfreetime")
    repo_dir      = File.join(parent_repo, "claudefiles")
    claude_config = File.expand_path("~/.claude")

    FileUtils.mkdir_p(parent_repo)

    %x[ git clone git@github.com:copiousfreetime/claudefiles.git #{repo_dir} ]
    %x[ ln -s #{repo_dir} #{claude_config} ]
  end

end
