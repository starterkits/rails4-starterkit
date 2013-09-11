require 'zeus/rails'

class CustomPlan < Zeus::Rails

  # def my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end

  def test
    require 'simplecov'
    require 'spec/support/simplecov_helpers'
    SimpleCov.start 'rails'

    SimpleCovHelpers::load_files_for_coverage

    # run the tests
    super
  end
end

Zeus.plan = CustomPlan.new
