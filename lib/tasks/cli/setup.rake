# frozen_string_literal: true

# rubocop:disable Rails/RakeEnvironment
namespace :cli do
  desc 'Setup project'
  task :setup do
    system('cp config/database.yml.example config/database.yml')

    _, _, is_dev, = ARGV

    unless is_dev == '--dev'
      gitignore = Rails.root.join('.gitignore')
      gitignore_content = gitignore.read
      gitignore.write(gitignore_content.gsub(%r{^/db/migrate/\*|^/db/schema.rb|^# remove below for your project}, '').strip.concat("\n"))
    end

    Rake::Task['cli:db:migrate'].execute
  end
end
# rubocop:enable Rails/RakeEnvironment
