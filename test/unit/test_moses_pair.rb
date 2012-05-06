require 'helper'

module AjaxCat

	class TestMosesPair < Test::Unit::TestCase
	  def test_moses_pair
	  	pair = MosesPair.new
	  	assert_equal(pair.class, MosesPair, "right class")
	  end
	end

end