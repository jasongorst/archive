namespace :deploy do
  desc 'Restart manticore searchd and solid_queue services.'
  before :published, :restart_manticore do
    on roles(:app) do
      execute :sudo, "systemctl", "restart", "manticore-archive"
    end
  end

  before :published, :restart_solid_queue do
    on roles(:app) do
      execute :sudo, "systemctl", "restart", "solid_queue-archive"
    end
  end
end
