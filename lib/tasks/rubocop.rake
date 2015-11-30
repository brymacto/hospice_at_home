unless Rails.env.production?
  require 'rubocop/rake_task'

  desc 'Run RuboCop and apply corrections'
  RuboCop::RakeTask.new('rubocop:auto_correct') do |task|
    task.options = %w(--auto-correct --display-cop-names --rails)
  end

  desc 'Run RuboCop and auto generate todo for failures'
  RuboCop::RakeTask.new('rubocop:gen_todo') do |task|
    task.options = %w(--auto-gen-config --display-cop-names --rails)
  end
end
