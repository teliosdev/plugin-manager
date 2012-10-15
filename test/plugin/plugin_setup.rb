#require 'test_plugin'

#class TestPluginSetup < Test::Unit::TestCase
#
# test "1copy instance methods" do
#   puts "ADD INSTANCE"
#   #assert_nothing_raised do
#     TestPlugin.enable
#   #end
#   assert AnotherClass.method_defined? :test_1
#   a = AnotherClass.new
#   assert_same a.test_1, a
#   assert TestPlugin.enabled?
# end
#
# test "2remove instance methods" do
#   puts "REMOVE INSTANCE"
#   p TestPlugin.enabled?
#   p AnotherClass.method_defined? :test_1
#   assert_nothing_raised do
#     TestPlugin.disable
#   end
#   assert_raise(NoMethodError) { AnotherClass.new.test_1 }
#   assert !(AnotherClass.method_defined? :test_1)
#   assert AnotherClass.method_defined? :object_id
# end
#
# test "3reenable plugin" do
#   assert !TestPlugin.enabled?
#   assert_nothing_raised do
#     TestPlugin.enable
#   end
#   assert AnotherClass.method_defined?(:test_1), "The `test_1' method is not defined."
# end
#
#end
