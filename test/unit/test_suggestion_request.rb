require 'helper'

module AjaxCat

	class TestSuggestionRequest < Test::Unit::TestCase
	  context "process suggestions" do

	  	setup do

	  	end

	  	should "parse suggestions right" do	  
	  		request = Request::Suggestion.new("das ist ein kleines haus", "11000", "  tohle    je")
	  		request.process_line("0 ||| tohle je a small house  ||| d: 0 lm: -25.9604 w: -3 tm: -1.60944 ||| -27.5698 ||| 2=2 3=3 4=4")
	  		request.process_line("0 ||| tohle je a little house  ||| d: 0 lm: -25.9604 w: -3 tm: -1.60944 ||| -27.5698 ||| 2=2 3=3 4=4")
	  		request.process_line("0 ||| tohle je an small house  ||| d: 0 lm: -25.9604 w: -3 tm: -1.60944 ||| -27.5698 ||| 2=2 3=3 4=4")
	  		request.process_line("0 ||| tohle je an small house  ||| d: 0 lm: -25.9604 w: -3 tm: -1.60944 ||| -27.5698 ||| 2=2 3=3 4=4")


	  		assert_equal(
	  			{
	  				"suggestions" => [
	  					"a small house",
	  					"a little house",
	  					"an small house"
	  				]
	  			}, request.result)
	  	end

	  end
	end
end
