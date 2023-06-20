# frozen_string_literal: true

module CodeTemplate
  def init_jquery_import
    "import './init_jquery';\n"
  end

  def init_ujs_import
    "import './init_ujs';\n"
  end

  def init_turbo_rails_import
    "import './init_turbo_rails';\n"
  end

  def controllers_import
    "import '~/controllers';"
  end

  def stimulus_hmr_import
    "import StimulusHMR from 'vite-plugin-stimulus-hmr';"
  end

  def stimulus_plugins
    'StimulusHMR(),'
  end
end
