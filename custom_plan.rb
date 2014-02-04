require 'zeus/rails'

class CustomPlan < Zeus::Rails

  # def my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end

  def test
    require 'simplecov'
    SimpleCov.start 'rails'

    # run the tests
    super
  end
end

Zeus.plan = CustomPlan.new
