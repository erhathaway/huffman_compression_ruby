require 'pry'
require_relative 'encode'
require_relative 'decode'

def print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
  puts "-"*50
  puts "Raw file name: \t : #{input_filename}"
  puts "Compressed file name: \t : #{output_filename}"
  puts "Raw file size: \t : #{raw_size} bytes"
  puts "Compressed file size: \t : #{compressed_size} bytes"
  puts "Compression took: \t : #{compression_time} seconds"
  compression_ratio=raw_size.to_f/compressed_size.to_f
  puts "Compressed file is: \t : #{((1-(compression_ratio**(-1))).round(2)*100).to_i} % smaller"
  puts "Compression ratio: \t : #{compression_ratio.round(2)} x"
  puts "-"*50
end

def encode_huffman(input_filename, output_filename)
  t1 = Time.now
	  raw_size = File.size(input_filename)*8
    @huffman_data = Encode.run(input_filename, output_filename)
	  compressed_size = File.size(output_filename)*8
  t2 = Time.now
  compression_time = (t2 - t1).round(2)
  print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
end


def decode_huffman(input_filename, output_filename, huffman_data)
  t1 = Time.now
    binary =  Decode.read(input_filename)[0].split("")
    Decode.decode(binary, huffman_data)
  t2 = Time.now
  compression_time = (t2 - t1).round(2)
  # print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
end

encode_huffman("../moby_dick.txt","../gold_fish.txt")
decode_huffman("../gold_fish.txt","out.txt", @huffman_data)
