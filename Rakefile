require 'rake'
require 'fileutils'

desc "Ensure ~/.config exists as a real directory"
task :ensure_config_dir do
  config_dir = File.expand_path("~/.config")

  if File.symlink?(config_dir)
    raise "~/.config (#{config_dir}) is a symlink to #{File.readlink(config_dir)}. " \
          "Install tasks expect ~/.config to be a real directory - move or remove " \
          "the symlink and re-run."
  end

  FileUtils.mkdir_p(config_dir)
end

desc "Ensure ~/repos/github.com/copiousfreetime exists"
task :ensure_my_repo_parent do
  FileUtils.mkdir_p(File.expand_path("~/repos/github.com/copiousfreetime"))
end

desc "Ensure all directories required by install tasks exist"
task :ensure_dirs => [:ensure_config_dir, :ensure_my_repo_parent]

# Clone (or update) a github repo under ~/repos/github.com/<owner>/<name> and
# symlink it into place at `target`. Used by tasks that manage their config
# via an external repo (e.g. vim, claude, opencode).
def sync_repo(repo:)
  repo_dir = File.expand_path("~/repos/github.com/#{repo}")

  if File.directory?(repo_dir)
    puts "==> Updating #{repo_dir}"
    system("git -C #{repo_dir} pull --rebase --autostash")
  else
    FileUtils.mkdir_p(File.dirname(repo_dir))
    puts "==> Cloning git@github.com:#{repo}.git -> #{repo_dir}"
    system("git clone git@github.com:#{repo}.git #{repo_dir}")
  end
  repo_dir
end

def sync_and_symlink_repo(repo:, target:)
  repo_dir = sync_repo(repo:)
  target = File.expand_path(target) # might be a ~/ prefixed

  if File.exist?(target)
    puts "#{target} is not a symlink, this is a problem" unless File.symlink?(target)
  else
    puts "Linking #{repo_dir} -> #{target}"
    FileUtils.ln_s(repo_dir, target)
  end
end

# Load in any *.rake files from the subfolders
Dir.glob("*/**/*.rake").each { |fn| load fn }

namespace :install do

  def install_linkable(linkable:, target:)
    overwrite = false
    backup = false

    skip_all = !!ENV['SKIP_ALL'] || false
    backup_all = !!ENV['BACKUP_ALL'] || false
    overwrite_all = false

    source = File.realpath(linkable)

    if File.exist?(target) && File.symlink?(target) && source == File.readlink(target)
      puts "Skipping #{linkable} - already set correctly"
    else
      if File.exist?(target) || File.symlink?(target)
        unless skip_all || overwrite_all || backup_all
          puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
          case STDIN.gets.chomp
          when 'o' then overwrite = true
          when 'b' then backup = true
          when 'O' then overwrite_all = true
          when 'B' then backup_all = true
          when 'S' then skip_all = true
          when 's' then return
          end
        end
        FileUtils.unlink(target) if overwrite || overwrite_all
        FileUtils.mv(target, "#{target}.backup") if backup || backup_all
      end
      puts "Linking #{source} -> #{target}"
      FileUtils.ln_s(source, target)
    end
  end

  desc "Install all the linkable files"
  task :linkable_files do
    extension = ".symlink"
    destination = File.expand_path("~/")

    glob_path = File.join("**", "*#{extension}")
    linkable_files = Dir.glob(glob_path)

    linkable_files.each do |linkable|
      basename = File.basename(linkable, extension)
      basename = ".#{basename}"
      target = File.join(destination, basename)
      install_linkable(linkable:, target:)
    end
  end

  desc "Install all the linkable dirs"
  task :linkable_dirs => :ensure_dirs do
    extension = ".config_link"
    destination = File.expand_path("~/.config")

    source_dir = File.dirname(__FILE__)
    glob_path = File.join(source_dir, "*#{extension}")

    linkable_dirs = Dir.glob(glob_path)

    linkable_dirs.each do |linkable|
      basename = File.basename(linkable, extension)
      target = File.join(destination, basename)
      install_linkable(linkable:, target:)
    end
  end


  desc "Install all the linkables"
  task :linkables => [:linkable_files, :linkable_dirs]

  desc "Install the gitconfig for #{ENV['USER']}"
  task :gitconfig_user do
    extension = ".#{ENV['USER']}"

    source_git_config_dir = "git"
    linkable = File.join(source_git_config_dir, "gitconfig-user#{extension}")

    destination = File.expand_path("~/")
    target = File.join(destination, ".gitconfig-user")

    if File.exist?(linkable)
      install_linkable(linkable:, target:)
    else
      puts "ERROR: #{linkable} does not exist"
    end
  end
end

desc "Hook our dotfiles into system-standard positions."
task :install => ["install:linkables", "install:gitconfig_user", "install:linkable_dirs"]

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end

    # Replace any backups made during installation
    if File.exist?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end
end

task :default => 'install'
