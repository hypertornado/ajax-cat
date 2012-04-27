require 'helper'

module AjaxCat

	module Request
		class TestRawRequest < Test::Unit::TestCase
		  def test_raw_request
		  	pair = AjaxCat::Request::Raw.new
		  	assert_equal(pair.class, Raw, "right class")
		  end
		end

	end

end