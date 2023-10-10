namespace :deploy do
  desc "Check if ssh-agent forwarding is working"
  before "git:check", :ensure_ssh_forwarding do
    on roles(:all) do |h|
      if test(:git, fetch(:repo_url))
        info "ssh-agent forwarding is up to #{h}"
      else
        warn "ssh-agent forwarding is NOT up to #{h}"
        invoke "deploy:add_keys"
      end
    end
  end

  task :add_keys do
    run_locally do
      execute :'ssh-add'
    end
  end
end
