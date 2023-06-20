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
    return @install_npm_packages_str if @install_npm_packages_str.present?

    @install_npm_packages_str = [].concat(NPM_PACKAGES)

    @install_npm_packages_str.concat(STIMULUS_PACKAGES) if stimulus?
    @install_npm_packages_str.concat(JQUERY_PACKAGES) if jquery?
    @install_npm_packages_str.concat(TURBO_RAILS_PACKAGES) if turbo_rails?

    @install_npm_packages_str = @install_npm_packages_str.join(' ')
  end

  def install_npm_dev_packages_str
    return @install_npm_dev_packages_str if @install_npm_dev_packages_str.present?

    @install_npm_dev_packages_str = [].concat(NPM_DEV_PACKAGES)

    @install_npm_dev_packages_str.concat(JQUERY_DEV_PACKAGES) if jquery?

    @install_npm_dev_packages_str = @install_npm_dev_packages_str.join(' ')
  end

  def jquery?
    @jquery ||= options[:jquery].present?
  end

  def stimulus?
    @stimulus ||= options[:stimulus].present?
  end

  def turbo_rails?
    @turbo_rails ||= options[:turbo_rails].present?
  end
end
