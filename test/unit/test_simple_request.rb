# encoding: utf-8
require 'helper'

module AjaxCat

	module Request

		class TestSimpleRequest < Test::Unit::TestCase

		  def test_process_line_and_get_result

		  	request = Simple.new("");
		  	File.new(File.dirname(__FILE__) + "/../fixtures/translation_table").each do |line|
		  		request.process_line(line)
		  	end
		  	result = "myslím , že tento dům je malá "
		  	assert_equal(result, request.result)

		  end

		end

	end

end