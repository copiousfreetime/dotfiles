require 'fileutils'

namespace :rbenv do
  rbenv_root = File.expand_path("~/.rbenv")
  ruby_build_root = File.join(rbenv_root, "plugins/ruby-build")

  task :install_rbenv do
    if File.directory?(rbenv_root) then
      $stderr.puts "rbenv exists -> #{rbenv_root}"
    else
      %x[ git clone https://github.com/rbenv/rbenv.git #{rbenv_root} ]
    end
  end

  task :install_ruby_build do
    if File.directory?(ruby_build_root) then
      $stderrr.puts "ruby-build plugin already insalled: #{ruby_build_root}"
    else
      %x[ git clone https://github.com/rbenv/ruby-build.git #{ruby_build_root} ]
    end

  end

  desc "Install rbenv/ruby-build"
  task :install => [:install_rbenv, :install_ruby_build]
end
