module OpenJd
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      def copy_yml_file
        copy_file 'jd.yml', 'config/jd.yml'
      end
    end
  end
end
