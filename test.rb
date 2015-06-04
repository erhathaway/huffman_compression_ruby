require 'bindata'
require 'objspace'

# puts '0b010'.to_i(2)
# puts 11730.to_s(2).encoding
# puts 11730.to_s.encoding

# puts '73'.unpack('B*')
# puts '0'.pack('b*')

bin_array = [%w[001 0011 01001 101 002].join(" ")]
# puts bin_array[0].to_i.to_s(2)

# puts bin_array.pack('a*').encoding
d = '1011111110001100'
c = ['10111111','100011']
p ObjectSpace.memsize_of(c)
a = [d].pack("B*")

p ObjectSpace.memsize_of(a)

File.write('compressed.txt', a)

p a.unpack("B*")
# .map{|x| x.to_s(10)}
# puts 0b01

# BinData::bit1
# File.open('test.bin', 'wb') {|file| BinData::Int32be.new(12345).write(file) }
