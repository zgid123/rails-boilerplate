# frozen_string_literal: true

module EnvHelper
  def invoke_action?
    behavior == :invoke
  end

  def revoke_action?
    behavior == :revoke
  end

  def extract_argv(support: :multiple_args)
    if support == :multiple_args
      packages = options[:packages].presence

      return [] if packages.blank? && options[:root].present?
      return packages if packages.present?

      if invoke_action?
        [ARGV.first]
      else
        [ARGV.second]
      end
    else
      invoke_action? ? ARGV.first : ARGV.second
    end
  end
end
