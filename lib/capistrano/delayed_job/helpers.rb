require 'erb'

module Capistrano
  module DelayedJob
    module Helpers

      def delayed_job_args
        args = []
        args << "-n #{fetch(:delayed_job_workers)}" unless fetch(:delayed_job_workers).nil?
        args << "--queues=#{fetch(:delayed_job_queues).join(',')}" unless fetch(:delayed_job_queues).nil?
        args << "--prefix=#{fetch(:delayed_job_prefix)}" unless fetch(:delayed_job_prefix).nil?
        args << "--pid-dir=#{fetch(:delayed_job_pid_dir)}" unless fetch(:delayed_job_pid_dir).nil?
        args << "--log-dir=#{fetch(:delayed_log_dir)}" unless fetch(:delayed_log_dir).nil?
        args << fetch(:delayed_job_pools, {}).map {|k,v| "--pool='#{k}:#{v}'"}.join(' ') unless fetch(:delayed_job_pools).nil?
        args.join(' ')
      end

      def bundle_delayed_job
        SSHKit::Command.new("RAILS_ENV=#{fetch(:stage)}", :bundle, :exec, delayed_job_bin, '$op', delayed_job_args).to_command
      end

      # renders the ERB template specified by template_name to string. Use the locals variable to pass locals to the
      # ERB template
      def template_to_s(template_name, locals = {})
        config_file = "#{fetch(:templates_path)}/#{template_name}"
        # if no customized file, proceed with default
        unless File.exists?(config_file)
          config_file = File.join(File.dirname(__FILE__), "../../generators/capistrano/delayed_job/templates/#{template_name}")
        end

        ERB.new(File.read(config_file), nil, '-').result(ERBNamespace.new(locals).get_binding)
      end

      # renders the ERB template specified by template_name to a StringIO buffer
      def template(template_name, locals = {})
        StringIO.new(template_to_s(template_name, locals))
      end

      def file_exists?(path)
        test "[ -e #{path} ]"
      end

      def sudo_upload!(from, to)
        filename = File.basename(to)
        to_dir = File.dirname(to)
        tmp_file = "#{fetch(:tmp_dir)}/#{filename}"
        upload! from, tmp_file
        sudo :mv, tmp_file, to_dir
      end

      # Helper class to pass local variables to an ERB template
      class ERBNamespace
        def initialize(hash)
          hash.each do |key, value|
            singleton_class.send(:define_method, key) { value }
          end
        end

        def get_binding
          binding
        end
      end
    end
  end
end
