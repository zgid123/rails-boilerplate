# frozen_string_literal: true

require 'generator_helpers/env_helper'
require_relative './constant'

module Helper
  include ActiveSupport::Concern
  include Constant
  include EnvHelper

  def packages
    @packages ||= extract_argv
  end

  def npm_command
    @npm_command ||= invoke_action? ? 'add -D' : 'remove'
  end

  def install_npm_packages_str
    @install_npm_packages_str ||= NPM_PACKAGES.join(' ')
  end

  def invoke_vite(params)
    Rails::Generators.invoke('vite', params) if invoke_action? && options[:'skip-vite'].blank?
  end
end
