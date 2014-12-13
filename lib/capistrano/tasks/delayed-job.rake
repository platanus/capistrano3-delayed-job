namespace :delayed_job do

  def args
    args = ""
    args += "-n #{delayed_job_workers}" unless fetch(:delayed_job_workers).nil?
    args += "--queues=#{delayed_job_queues.join(',')}" unless fetch(:delayed_job_queues).nil?
    args += delayed_job_pool.map {|k,v| "--pool=#{k}:#{v}"}.join(' ') unless fetch(:delayed_job_pool).nil?
  end

  def delayed_job_roles
    fetch(:delayed_job_server_role)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'script/delayed_job', :stop
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'script/delayed_job', args, :start
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'script/delayed_job', args, :restart
        end
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
    set :delayed_job_pool, nil
    set :delayed_job_roles, :app
  end
end
