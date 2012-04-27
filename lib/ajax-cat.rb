#echo "i think that this house is small" | ./moses -f en-cs/moses.ini  -n-best-list - 10 distinct -include-alignment-in-n-best true 2>/dev/null

require 'sinatra.rb'
require 'ajax-cat/moses_pair.rb'

get '/' do
  redirect '/index.html'
end