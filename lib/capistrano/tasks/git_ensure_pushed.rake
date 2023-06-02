namespace :deploy do
  set :remote, `git remote`.chomp

  desc 'Ensures local repository is pushed to remote.'
  before :check, :ensure_pushed do
    run_locally do
      if test "[ $(git log #{fetch(:remote)}/#{fetch(:branch)}..#{fetch(:branch)} | wc -l) -ne 0 ]"
        warn "Your branch #{fetch(:branch)} needs to be pushed to #{fetch(:remote)} before deploying"
        exit(false)
      else
        info "Your branch #{fetch(:branch)} is up to date on remote #{fetch(:remote)}"
      end
    end
  end
end
