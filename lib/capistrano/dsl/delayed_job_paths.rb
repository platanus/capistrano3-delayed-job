module Capistrano
  module DSL
    module DelayedJobPaths

      def delayed_job_initd_file
        "/etc/init.d/#{fetch(:delayed_job_service)}"
      end

      def delayed_job_bin
        Pathname.new(fetch(:delayed_job_bin_path)).join('delayed_job')
      end

    end
  end
end
