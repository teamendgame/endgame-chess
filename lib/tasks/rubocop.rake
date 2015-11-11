require 'rubocop/rake_task'

unless Rails.env.test?
  RuboCop::RakeTask.new
end