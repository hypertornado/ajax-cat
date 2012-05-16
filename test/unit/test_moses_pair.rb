require 'helper'

module AjaxCat

	class TestMosesPair < Test::Unit::TestCase
	  def test_moses_pair
	  	moses_ini_path = File.dirname(__FILE__) + "/../fixtures/moses.ini"
	  	@pair = MosesPair.new('cs-en',"moses",moses_ini_path)
	  	puts moses_ini_path
	  	assert_equal(@pair.class, MosesPair, "right class")
	  	request = Request::Raw.new("das ist")
	  	result = @pair.process_request(request)
	  	puts result
	  	assert_equal(616, result.size)
	  end
	end

end