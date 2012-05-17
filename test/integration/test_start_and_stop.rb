require 'helper'

module AjaxCat

	class TestStartAndStop < Test::Unit::TestCase
	  context "run app" do

	  	setup do
	  		Dir.chdir(File.dirname(__FILE__) + "/../fixtures/")
	  		@port = 8585
	  		@pid = fork do
	  			Runner.new(@port)
	  		end
	  		server_started = false
	  		1000.times do
	  			raised = false
	  			begin
	  				Curl::Easy.perform("http://localhost:#{@port}/index.html")
	  			rescue
	  				raised = true
	  			end
	  			unless raised
	  				server_started = true
	  				break
	  			end
	  			sleep 0.01
	  		end
	  		raise "cant start server" unless server_started
	  	end

	  	should "start server on default port" do
	  		result = Curl::Easy.perform("http://localhost:#{@port}/index.html")
	  		assert_equal 200, result.response_code

	  		result = Curl::Easy.perform("http://localhost:#{@port}/api/raw?q=das+ist&pair=de-en")
	  		assert_equal 200, result.response_code
	  		assert_equal(616, result.body_str.size)
	  	end

	  	teardown do
	  		Process.kill 'TERM', @pid
	  	end

	  end
	end

end