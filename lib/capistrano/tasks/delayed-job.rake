require 'capistrano/delayed_job/helpers'
require 'capistrano/dsl/delayed_job_paths'

include Capistrano::DelayedJob::Helpers
include Capistrano::DSL::DelayedJobPaths

namespace :delayed_job do

  def delayed_job_roles
    fetch(:delayed_job_roles)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      sudo 'service', fetch(:delayed_job_service), 'stop'
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      sudo 'service', fetch(:delayed_job_service), 'start'
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      sudo 'service', fetch(:delayed_job_service), 'restart'
    end
  end

  desc 'Setup Delayed Job initializer'
  task :setup_initializer do
    on roles(:all) do |host|
      execute sudo :rm, '-f', delayed_job_initd_file
      sudo 'update-rc.d', '-f', fetch(:delayed_job_service), 'remove'
    end
    on roles fetch(:delayed_job_roles) do |server|
      set :delayed_job_user, server.user
      sudo_upload! template('delayed_job_init.erb'), delayed_job_initd_file
      execute :chmod, '+x', delayed_job_initd_file
      sudo 'update-rc.d', '-f', fetch(:delayed_job_service), 'defaults'
    end
  end

  after 'deploy:published', 'restart' do
    invoke 'delayed_job:restart'
  end

end

namespace :load do
  task :defaults do
    set :delayed_job_workers, 1
    set :delayed_job_queues, nil
    set :delayed_job_pools, nil
    set :delayed_job_roles, :app
    set :delayed_job_bin_path, 'bin'
    set :delayed_job_service, -> { "delayed_job_#{fetch(:application)}_#{fetch(:stage)}" }
    set :templates_path, 'config/deploy/templates'
  end
end
