# encoding: utf-8
require 'helper'

module AjaxCat

	module Request

		class TestRawRequest < Test::Unit::TestCase

			def test_can_read_fixture
				text = File.readlines(File.dirname(__FILE__) + "/../fixtures/translation_table")[0].chop
		  	assert_equal(text,
		  		"10 ||| myslím , že tento dům je malá  ||| d: 0 lm: -33.2059 w: -7 tm: -3.67773 -6.51247 -6.97174 -12.6506 3.99959 ||| -4.63843 ||| 0-1=0 2=1-2 3-5=3-5 6=6",
		  		"fixture string is same"
		  	)
			end

		  def test_parse_position
		  	text = File.readlines(File.dirname(__FILE__) + "/../fixtures/translation_table")[0].chop
		  	position = Raw.parse_position(text)
		  	assert_equal(10, position, "parsing position")
		  end

		  def test_process_line_and_get_result

		  	request = Raw.new;
		  	File.new(File.dirname(__FILE__) + "/../fixtures/translation_table").each do |line|
		  		request.process_line(line)
		  	end

		  	assert_equal(File.read(File.dirname(__FILE__) + "/../fixtures/translation_table"), request.result)

		  end

		end

	end

end