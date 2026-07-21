
require 'fileutils'

namespace :llm_harness do

  namespace :claude do
    task :ensure_config_installed do
      puts "==> Installing ~/.claude directory"
      sync_and_symlink_repo(repo: "copiousfreetime/claudefiles", target: "~/.claude")
    end

    # the installer uses ~/.claude directory for the downloads
    task :ensure_bin_installed => :ensure_config_installed do
      puts "==> Installing claude code"
      system("curl -fsSL https://claude.ai/install.sh | bash")
    end

    desc "Install claude code and its config"
    task :install => [:ensure_bin_installed]
  end


  namespace :opencode do

    task :ensure_bin_installed do
      puts "==> Installing opencode"
      system("curl -fsSL https://opencode.ai/install | bash")
    end

    task :ensure_config_installed do
      puts "==> Installing opencode config"
      sync_and_symlink_repo(repo: "copiousfreetime/opencode-files", target: "~/.config/opencode")
    end

    desc "Install opencode and its config"
    task :install => [:ensure_bin_installed, :ensure_config_installed ]
  end

  namespace :cantrips do

    cantrips_repo = nil

    task :ensure_sync do
      cantrips_repo = sync_repo(repo: "copiousfreetime/copious-cantrips")
    end

    task :install_into_opencode => ["opencode:install", :ensure_sync] do
      puts "==> Installing cantrips into opencode #{cantrips_repo}"
      Dir.chdir(cantrips_repo) do
        system("./install.sh")
      end
    end

    desc "Install the cantrips"
    task :install => [:install_into_opencode]
  end

  desc "Install all the llm harnesses"
  task :install => ["claude:install", "opencode:install", "cantrips:install"]
end
