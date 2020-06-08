namespace :setup do

  desc 'Upload database.yml file.'
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read('config/database.remote.yml')), "#{shared_path}/config/database.yml"
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
