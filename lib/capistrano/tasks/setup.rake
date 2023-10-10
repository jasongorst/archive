namespace :setup do
  desc 'Upload shared config files.'
  task :upload_shared do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read('config/database.example.yml')), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read('config/master.key')), "#{shared_path}/config/master.key"
      upload! StringIO.new(File.read('config/en.pak')), "#{shared_path}/config/en.pak"
    end
  end

  desc 'Seed the database.'
  task :seed_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end
