require 'helper'

module AjaxCat

	class TestMosesPair < Test::Unit::TestCase
	  def test_moses_pair
	  	@pair = MosesPair.new('cs-en',"moses","#{Dir.pwd}/test/fixtures/moses.ini")
	  	assert_equal(@pair.class, MosesPair, "right class")
	  	request = Request::Raw.new("das ist")
	  	result = @pair.process_request(request)
	  	assert_equal(616, result.size)
	  end
	end

end