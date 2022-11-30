namespace :deploy do
  desc 'Clobber assets before compiling.'
  before :compile_assets, :clobber_assets_before_compile do
    invoke 'deploy:clobber_assets'
  end
end
