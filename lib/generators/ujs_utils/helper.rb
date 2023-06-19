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

  def npm_command(is_dev: false)
    @npm_command = if invoke_action?
                     "add #{is_dev ? '-D' : ''}".strip
                   else
                     'remove'
                   end
  end

  def install_npm_packages_str
    @install_npm_packages_str ||= NPM_PACKAGES.join(' ')
  end

  def install_npm_dev_packages_str
    @install_npm_dev_packages_str ||= NPM_DEV_PACKAGES.join(' ')
  end
end
