require 'helper'

module AjaxCat

	module Request
		class TestRawRequest < Test::Unit::TestCase
		  def parse_order
		  	line = File.readlines(__FILE__ + "translation_table")[0].chop
		  end
		end

	end

end