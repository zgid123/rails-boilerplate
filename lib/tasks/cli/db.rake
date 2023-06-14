# frozen_string_literal: true

namespace :cli do
  namespace :db do
    desc 'Migrate the database with all plugins\' migrations'
    task migrate: :environment do
      package_dir = Rails.root.join('packages')

      packages = Dir.entries(package_dir).select do |folder|
        File.directory?("#{package_dir}/#{folder}") && ['.', '..'].exclude?(folder)
      end

      multitask all: packages.map { |package| "#{package}:install:migrations" }

      Rake::MultiTask[:all].invoke

      Rake::Task['db:migrate'].execute
    end
  end
end
