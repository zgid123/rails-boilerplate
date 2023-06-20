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

  def install_npm_packages
    return @install_npm_packages if @install_npm_packages.present?

    @install_npm_packages = [].concat(UJS_UTILS_NPM_PACKAGES)

    @install_npm_packages.concat(UJS_UTILS_STIMULUS_PACKAGES) if stimulus?
    @install_npm_packages.concat(UJS_UTILS_JQUERY_PACKAGES) if jquery?
    @install_npm_packages.concat(UJS_UTILS_TURBO_RAILS_PACKAGES) if turbo_rails?

    @install_npm_packages
  end

  def install_npm_dev_packages
    return @install_npm_dev_packages if @install_npm_dev_packages.present?

    @install_npm_dev_packages = [].concat(UJS_UTILS_NPM_DEV_PACKAGES)

    @install_npm_dev_packages.concat(UJS_UTILS_JQUERY_DEV_PACKAGES) if jquery?

    @install_npm_dev_packages
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
