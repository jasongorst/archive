namespace :deploy do
  desc "Ensures local repository is pushed to remote."
  before :check, :ensure_pushed do
    invoke "deploy:set_remote" unless fetch(:remote)

    run_locally do
      if test "[ $(git log #{fetch(:remote)}/#{fetch(:branch)}..#{fetch(:branch)} | wc -l) -ne 0 ]"
        warn "Your branch #{fetch(:branch)} needs to be pushed to #{fetch(:remote)}"
        invoke "deploy:git_push"
      else
        info "Your branch #{fetch(:branch)} is up to date on remote #{fetch(:remote)}"
      end
    end
  end

  desc "Push local changes to remote"
  task :git_push do
    invoke "deploy:set_remote" unless fetch(:remote)

    run_locally do
      execute :git, "push #{fetch(:remote)} #{fetch(:branch)}"
    end
  end

  task :set_remote do
    set :remote do
      run_locally do
        capture :git, "config --get branch.main.remote"
      end
    end
  end
end
