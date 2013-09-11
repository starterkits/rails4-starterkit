module SimpleCovHelpers
  # Manually loading files helps ensure accurate coverage reports
  # between `./bin/rspec` and `zeus test spec/`
  def self.load_files_for_coverage
    Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
    Dir["#{Rails.root}/lib/**/*.rb"].each { |f| load f }
    Dir["#{Rails.root}/vendor/**/*.rb"].each { |f| load f }
  end
end
