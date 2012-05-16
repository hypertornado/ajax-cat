require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'
require 'curb'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ajax-cat'

@moses_ini = <<-END
#########################
### MOSES CONFIG FILE ###
#########################

# input factors
[input-factors]
0

# mapping steps, either (T) translation or (G) generation
[mapping]
T 0

# translation tables: source-factors, target-factors, number of scores, file
[ttable-file]
0 0 0 1 #{Dir.pwd}/test/fixtures/phrase-table

# language models: type(srilm/irstlm/kenlm), factors, order, file
[lmodel-file]
8 0 3 #{Dir.pwd}/test/fixtures/europarl.srilm.gz

# limit on how many phrase translations e for each phrase f are loaded
[ttable-limit]
10

# distortion (reordering) weight
[weight-d]
1

# language model weights
[weight-l]
1

# translation model weights
[weight-t]
1

# word penalty
[weight-w]
0

[n-best-list]
nbest.txt
100



END

f = File.new(File.dirname(__FILE__) + "/fixtures/moses.ini", "w")
f.write(@moses_ini)
f.close
