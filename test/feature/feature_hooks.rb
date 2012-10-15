require 'feature_plugin'

class TestFeatureHooks < Test::Unit::TestCase

  test "adds hooks to list" do
    assert_equal Feature1.instance_variable_get(:@_enable_hooks), [:run]
  end

  test "runs hooks" do
    assert_nothing_raised do
      Feature1.enable
    end
    assert Feature1.instance_variable_get(:@run_called)
  end

end
