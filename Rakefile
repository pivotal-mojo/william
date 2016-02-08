# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :default => [:spec, :eslint, 'jasmine:ci']

task :eslint do
  puts 'Running eslint against production code'
  puts %x{node_modules/.bin/eslint app/assets/javascripts}
  puts ''
  puts 'Running eslint against javascript tests'
  puts %x{node_modules/.bin/eslint -c .eslintrc.specs.json spec/javascripts}
end