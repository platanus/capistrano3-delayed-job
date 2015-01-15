namespace :delayed_job do

  def delayed_job_args
    args = []
    args << "-n #{fetch(:delayed_job_workers)}" unless fetch(:delayed_job_workers).nil?
    args << "--queues=#{fetch(:delayed_job_queues).join(',')}" unless fetch(:delayed_job_queues).nil?
    args << fetch(:delayed_job_pools, {}).map {|k,v| "--pool=#{k}:#{v}"}.join(' ') unless fetch(:delayed_job_pools).nil?
    args.join(' ')
  end

  def delayed_job_roles
    fetch(:delayed_job_roles)
  end

  def delayed_job_bin
    Pathname.new(fetch(:delayed_job_bin_path)).join('delayed_job')
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, delayed_job_bin, :stop
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

  before :restart, :fix_delayed_job_not_executable

  desc 'Fix problem when delayed_job is not executable'
  task :fix_delayed_job_not_executable do
    on roles(delayed_job_roles) do
      within release_path do
         execute :chmod, '+x', delayed_job_bin
      end
    end
  end

  after 'deploy:publishing', 'restart' do
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
  end
end
