require 'rails'

module OpenJd
  class Railtie < Rails::Railtie
    generators do
      require 'generators/open_jd/install_generator'
    end

    initializer 'load jd.yml' do
      config_file = Rails.root + 'config/jd.yml'
      OpenJd.load(config_file) if config_file.file?
    end
  end
end
