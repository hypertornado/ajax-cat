require 'helper'


#include Test::Integration
module AjaxCat

	class TestStartAndStop < Test::Unit::TestCase
	  context "run app" do

	  	setup do
	  		@port = 8585
	  		@pid = fork do
	  			Starter.start(@port, false)
	  		end
	  	end

	  	should "start server on default port 8585" do
	  		sleep 3
	  		result = Curl::Easy.perform("http://localhost:#{@port}/index.html")
	  		assert_equal 200, result.response_code
	  	end

	  	teardown do
	  		Process.kill 'TERM', @pid
	  	end

	  end
	end

end