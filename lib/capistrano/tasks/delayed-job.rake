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
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, delayed_job_bin, delayed_job_args, :stop
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, delayed_job_bin, delayed_job_args, :start
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, delayed_job_bin, delayed_job_args, :restart
        end
      end
    end
  end

  desc 'Setup Delayed Job initializer'
  task :setup_initializer do
    puts "*********************************************************"
    on roles(:all) do |host|
      puts "======================================================="
      execute sudo :rm, '-f', delayed_job_initd_file
      sudo 'update-rc.d', '-f', fetch(:delayed_job_service), 'remove'
    end
    on roles fetch(:delayed_job_roles) do |server|
      puts "--------------------------------------------------------"
      set :delayed_job_user, server.user
      sudo_upload! template('delayed_job_init.erb'), delayed_job_initd_file
      execute :chmod, '+x', delayed_job_initd_file
      sudo 'update-rc.d', '-f', fetch(:delayed_job_service), 'defaults'
    end
    puts "*********************************************************"
  end

  after 'deploy:published', 'restart' do
    invoke 'delayed_job:restart'
  end

  after 'deploy:published' do
    invoke 'delayed_job:setup_initializer'
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
