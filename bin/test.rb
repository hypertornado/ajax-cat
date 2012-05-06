

f = open 'pipe', File::RDWR|File::NONBLOCK

while l = f.readline
	puts l
end

puts "END"