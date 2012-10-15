require File.absolute_path('../../lib/plugin_manager', __FILE__)
$: << File.absolute_path('../init', __FILE__)

require 'plugin_manager'
require 'test/unit'

class Test::Unit::TestCase
  class << self
    def test(name, &block)
      define_method "test_#{name.gsub(' ', '_')}", &block
    end
  end
end

Dir["./**/*.rb"].each do |d|
  require d
end
