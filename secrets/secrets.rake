require 'fileutils'

# Describe the secrets to store in the iCloud Drive encrypted disk image.
#
# The key is the folder in the encrypted disk image where the secrets will be
# stored. The sub-hash describes the `:local` directory for the files, and the
# `:glob` patterns used to match the files that will be copied.
FILES = {
  "ssh" => {
    local: "~/.ssh",
    glob:  "**/*"
  },
  "secret" => {
    local: "~/.dotfiles/secret",
    glob:  "**/*"
  },
  "keybase" => {
    local: "~/.keybase",
    glob: "**/*"
  },
  "keybase-installer" => {
    local: "~/.keybase-installer",
    glob: "**/*"
  },
  "aws" => {
    local: "~/.aws",
    glob: %[ config credentials ]
  },
  "keybox" => {
    local: "~/.keybox",
    glob: "**/*"
  },
  "ngrok2" => {
    local: "~/.ngrok2",
    glob: "**/*"
  },
  "netrc" => {
    local: "~/.netrc",
    single_file: true
  } ,
  "pgpass" => {
    local: "~/.pgpass",
    single_file: true
  }
}

ICLOUD_DRIVE = "#{ENV['HOME']}/Library/Mobile Documents/com~apple~CloudDocs".freeze
VOLUME_NAME  = "Secrets".freeze
VOLUME       = File.join("", "Volumes", VOLUME_NAME).freeze
DMG_FILE     = File.join(ICLOUD_DRIVE, "secrets.dmg").freeze

namespace :secrets do
  desc "Install secrets from iCloud Drive"
  task :install => %i[setup install_files teardown]

  desc "Backup secrets to iCloud Drive"
  task :backup => %i[setup backup_files teardown]

  desc "Delete secrets from iCloud Drive"
  task :clobber => :teardown do
    puts "Deleting encrypted secrets disk image from iCloud Drive"
    FileUtils.rm_rf(DMG_FILE)
  end

  # Performs the actual work of install files from iCloud Drive
  # into their appropriate locations
  task :install_files do
    puts "Installing files from the encrypted disk image ..."
    pwd = Dir.pwd
    begin
      FILES.each do |backup, h|

        local    = h[:local]
        src_dir  = File.join(VOLUME, backup)
        dest_dir = File.expand_path(local)

        if h.has_key?(:single_file) && (h[:single_file] == true)
          b        = File.basename(dest_dir)
          dest_dir = File.expand_path("~")

          d        = File.join(dest_dir, b)
          d_name   = local

          s        = File.join(src_dir, b)
          s_name   = File.join(backup, b)

          if !File.exists?(d) || (File.mtime(s) > File.mtime(d))
            puts "Copying:  #{s_name.inspect} --> #{d_name.inspect}"
            FileUtils.mkdir_p(File.dirname(d))
            FileUtils.cp(s, d, preserve: true)
          else
            puts "Skipping: #{s_name.inspect} --> #{d_name.inspect}"
          end

        else
          # skip these files if the backup directory does not exist
          next unless File.exists?(src_dir) && File.directory?(src_dir)

          Dir.chdir(src_dir)

          Dir.glob("**/*").each do |file|
            next if File.directory?(file)

            d      = File.join(dest_dir, file)
            d_name = File.join(local,    file)

            s      = File.join(src_dir, file)
            s_name = File.join(backup,  file)

            if !File.exists?(d) || (File.mtime(s) > File.mtime(d))
              puts "Copying:  #{s_name.inspect} --> #{d_name.inspect}"
              FileUtils.mkdir_p(File.dirname(d))
              FileUtils.cp(s, d, preserve: true)
            else
              puts "Skipping: #{s_name.inspect} --> #{d_name.inspect}"
            end
          end
        end
      end
    ensure
      Dir.chdir(pwd)
    end
  end

  # Performs the actual work of backing up files to iCloud Drive
  task :backup_files do
    puts "Backing up files to the encrypted disk image ..."
    pwd = Dir.pwd
    begin
      FILES.each do |backup, h|
        local = h[:local]
        globs = h[:glob]

        dest_dir = File.join(VOLUME, backup)

        if h.has_key?(:single_file) && (h[:single_file] == true)
          s      = File.expand_path(local)
          s_name = backup
          b      = File.basename(s)

          d      = File.join(dest_dir, b)
          d_name = File.join(backup, b)

          if !File.exists?(d) || (File.mtime(s) > File.mtime(d))
            puts "Copying:  #{s_name.inspect} --> #{d_name.inspect}"
            FileUtils.mkdir_p(File.dirname(d))
            FileUtils.cp(s, d, preserve: true)
          else
            puts "Skipping: #{s_name.inspect} --> #{d_name.inspect}"
          end
        else
          # skip these files if the local directory does not exist
          src_dir = File.expand_path(local)
          next unless File.exists?(src_dir) && File.directory?(src_dir)

          Dir.chdir(src_dir)

          Array(globs).each do |glob|
            Dir.glob(glob).each do |file|
              next if File.directory?(file)

              d      = File.join(dest_dir, file)
              d_name = File.join(backup,   file)

              s      = File.join(src_dir, file)
              s_name = File.join(local,   file)

              if !File.exists?(d) || (File.mtime(s) > File.mtime(d))
                puts "Copying:  #{s_name.inspect} --> #{d_name.inspect}"
                FileUtils.mkdir_p(File.dirname(d))
                FileUtils.cp(s, d, preserve: true)
              else
                puts "Skipping: #{s_name.inspect} --> #{d_name.inspect}"
              end
            end
          end
        end
      end
    ensure
      Dir.chdir(pwd)
    end
  end

  task :setup => %i[create_dmg mount_volume]

  task :teardown => :detach_volume

  task :create_dmg do
    unless File.exists? DMG_FILE
      cmd = %Q{hdiutil create -type UDIF -encryption AES-256 -size 25m -fs "Journaled HFS+" -volname "#{VOLUME_NAME}" -attach "#{DMG_FILE}"}
      puts "Creating an ecrypted disk image for storing secrets ..."
      puts cmd
      Kernel.system cmd
    end
  end

  task :mount_volume do
    unless File.exists? VOLUME
      cmd = %Q{hdiutil attach "#{DMG_FILE}"}
      puts "Mounting encrypted secrets disk image ..."
      puts cmd
      Kernel.system cmd
    end
  end

  task :detach_volume do
    if File.exists? VOLUME
      cmd = %Q{hdiutil detach "#{VOLUME}"}
      puts "Detaching encrypted secrets disk image ..."
      puts cmd
      Kernel.system cmd
    end
  end
end
