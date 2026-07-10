require 'fileutils'

namespace :opencode do
  desc 'Install custom opencode files'
  task :install => :ensure_dirs do
    parent_repo     = File.expand_path('~/repos/github.com/copiousfreetime')
    repo_dir        = File.join(parent_repo, 'opencode-files')
    config_dir      = File.expand_path('~/.config')
    opencode_config = File.join(config_dir, 'opencode')

    %x[ git clone git@github.com:copiousfreetime/opencode-files.git #{repo_dir} ] unless File.directory?(repo_dir)

    if File.exist?(opencode_config) then
      if !File.symlink?(opencode_config) then
        puts "#{opencode_config} is not a symlink, this is a problem"
      end
    else
      %x[ ln -s #{repo_dir} #{opencode_config} ]
    end
  end
end
