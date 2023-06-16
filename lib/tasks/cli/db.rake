# frozen_string_literal: true

namespace :cli do
  namespace :db do
    desc 'Migrate the database with all plugins\' migrations'
    task migrate: :environment do
      require 'package_helper'

      include PackageHelper

      rake_task_names = package_folders.each_with_object([]) do |package, result|
        next result unless Rake::Task.task_defined?("#{package}:install:migrations")

        result << "#{package}:install:migrations"
      end

      multitask all: rake_task_names

      Rake::MultiTask[:all].invoke

      Rake::Task['db:migrate'].execute
    end
  end
end
