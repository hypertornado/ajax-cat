require 'helper'

module AjaxCat

	class TestPairs < Test::Unit::TestCase
	  context "run pairs from file" do

	  	setup do
	  		moses_ini_path = File.dirname(__FILE__) + "/../fixtures/moses.ini"
	  		@pair_name = 'de-en'
	  		@settings = {
	  			"pairs" => [
	  				{
	  					"name" => @pair_name,
	  					"moses_path" => 'moses',
	  					"moses_ini_path" => moses_ini_path
	  				},
	  				{
	  					"name" => @pair_name + "-2",
	  					"moses_path" => 'moses',
	  					"moses_ini_path" => moses_ini_path
	  				}
	  			]
	  		}
	  	end

	  	should "pairs should be started" do

	  		pairs = Pairs.new(@settings)

	  		result = pairs.process_request(Request::Raw.new("das ist"), @pair_name)
	  		assert_equal(616, result.size)
	  		assert_equal(['de-en','de-en-2'], pairs.list)
	  	end

	  	teardown do
	  		
	  	end

	  end
	end

end