# frozen_string_literal: true

require 'generator_helpers/env_helper'

module Helper
  include ActiveSupport::Concern
  include EnvHelper

  def packages
    @packages ||= extract_argv
  end

  def invoke_vite(params)
    Rails::Generators.invoke('vite', params) if invoke_action? && options[:'skip-vite'].blank?
  end
end
