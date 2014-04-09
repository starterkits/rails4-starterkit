desc 'Reset all data for demo servers'
task :reset_all_data => :environment do
  User.destroy_all
end
