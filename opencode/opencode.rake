require 'fileutils'

namespace :opencode do
  desc 'Install custom opencode files'
  task :install do
    parent_repo     = File.expand_path('~/repos/github.com/copiousfreetime')
    repo_dir        = File.join(parent_repo, 'opencode-files')
    config_dir      = File.expand_path('~/.config')
    opencode_config = File.join(config_dir, 'opencode')

    FileUtils.mkdir_p(parent_repo)
    FileUtils.mkdir_p(config_dir)

    %x[ git clone git@github.com:copiousfreetime/opencode-files.git #{repo_dir} ]
    %x[ ln -s #{repo_dir} #{opencode_config} ]
  end
end
