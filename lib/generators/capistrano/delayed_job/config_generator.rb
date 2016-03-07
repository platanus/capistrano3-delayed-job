module Capistrano
  module DelayedJob
    module Generators
      class ConfigGenerator < Rails::Generators::Base
        desc "Create local delayed job initializer configuration files for customization"
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: "config/deploy/templates",
          banner: "path to templates"

        def copy_template
          copy_file "delayed_job_init.erb", "#{templates_path}/delayed_job_init.erb"
        end
      end
    end
  end
end
