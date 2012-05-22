require 'helper'

module AjaxCat

	class TestTableRequest < Test::Unit::TestCase
	  context "process table" do

	  	setup do
	  		@logger = Logger.new("prefix")
	  	end

	  	should "parse table right" do	  
	  		request = Request::Table.new("   das 	 ist ein ")
	  		request.process_line("464 ||| this is a  ||| d: 0 lm: -15.6027 w: -3 tm: -0.223144 ||| -15.8259 ||| 0-1=0-1 2=2")
	  		request.process_line("464 ||| this is an  ||| d: 0 lm: -16.3011 w: -3 tm: -0.223144 ||| -16.5242 ||| 0-1=0-1 2=2")
	  		request.process_line("464 ||| ann this is  ||| d: -5 lm: -29.8134 w: -3 tm: -0.223144 ||| -35.0366 ||| 2=0 0=1-2")

	  		assert_equal(
	  			{
	  				"source" => ["das","ist","ein"],
	  				"table" =>
	  				[
	  					[
	  						{
	  							"str" => "this is",
	  							"w" => 2
	  						},
	  						{
	  							"str" => "a",
	  							"w" => 1
	  						}
	  					],
	  					[
	  						{
	  							"str" => "this is",
	  							"w" => 1
	  						},
	  						{
	  							"w" => 1
	  						},
	  						{
	  							"str" => "an",
	  							"w" => 1
	  						}
	  					],
	  					[
	  						{
	  							"w" => 2
	  						},
	  						{
	  							"str" => "ann",
	  							"w" => 1
	  						}
	  					]
	  				]
	  			}, request.result)
	  	end

	  end
	end
end
