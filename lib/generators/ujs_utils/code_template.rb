# frozen_string_literal: true

module CodeTemplate
  def rails_ujs_import
    "import Rails from '@rails/ujs';"
  end

  def jquery_import
    "import 'jquery';"
  end

  def command_import
    'Rails.start();'
  end
end
