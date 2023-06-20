# frozen_string_literal: true

module CliHelper
  def rubocop_on(files)
    return if files.blank?

    joined_files = files.is_a?(Array) ? files.join(' ') : files
    system("bundle exec rubocop -f q -a #{joined_files}")
  end

  def pnpm_install
    system('pnpm install')
  end

  def pnpm_add(packages, behavior:, is_dev: false, global: false, workspaces: [])
    system("pnpm #{pnpm_workspace(global, workspaces)} #{pnpm_command(behavior, is_dev)} #{packages.join(' ')}")
  end

  private

  def pnpm_command(behavior, is_dev)
    if behavior == :invoke
      command = 'add'

      command += ' -D' if is_dev

      command
    else
      'remove'
    end
  end

  def pnpm_workspace(global, workspaces)
    if global.present?
      '-w'
    else
      workspaces = [workspaces] unless workspaces.is_a?(Array)

      workspaces.map do |workspace|
        "--filter=#{workspace}"
      end.join(' ')
    end
  end
end
