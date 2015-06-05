require 'pry'
require 'optparse'
require_relative 'lib/encode'
require_relative 'lib/decode'

options = {}

ARGV << '-h' if ARGV.empty?

parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby huffman.rb [options]"
    
    #-----ARGUMENTS-----
    # Input file
    opts.on("-i", "--in FILE_LOCATION", String, "Input file (specify relative path)") do |i|
        options[:in] = i
    end
    
    # Output file
    opts.on("-o", "--out FILE_LOCATION", String, "Output file (specify relative path)") do |o|
        options[:out] = o
    end

    # Decode flag
    opts.on("-d", "--decode", String, "Decode a file ") do 
        options[:@state] = 'decode'
    end

    # Encode flag
    opts.on("-e", "--encode", String, "Encode a file") do 
        options[:@state] = 'encode'
    end

    # Print the command line options
    opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
    end
end

parser.parse!

#-----HANDLE ARGUMENTS-----
if options[:in]
    input_filename = options[:in]
else
    abort("You must specify a input file using '--in'")
end

if options[:out]
    output_filename = options[:out]
else
  output_filename = nil
end

if options[:@state]
  @state = options[:@state]
else 
    abort("You must specify whether you want to encode '-e' or decode '-d' a file")
end



def print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
  puts "-"*50
  if @state == 'encode'
      puts 'ENCODING RESULTS'
  elsif @state == 'decode'
      puts 'DECODING RESULTS'
  end

  puts "Raw file name: \t \t : #{input_filename}"
  puts "Compressed file name: \t : #{output_filename}"
  puts "Raw file size: \t \t : #{raw_size} bytes"
  puts "Compressed file size: \t : #{compressed_size} bytes"
  puts "Compression took: \t : #{compression_time} seconds"
  compression_ratio=raw_size.to_f/compressed_size.to_f
  puts "Compressed file is: \t : #{((1-(compression_ratio**(-1))).round(2)*100).to_i} % smaller"
  puts "Compression ratio: \t : #{compression_ratio.round(2)} x"
  puts "-"*50
end

def encode_huffman(input_filename,output_filename=nil)
  if output_filename == nil
    output_filename = input_filename+'.huf'
  end
  t1 = Time.now
	  raw_size = File.size(input_filename)*8
    Encode.run(input_filename, output_filename)
	  compressed_size = File.size(output_filename)*8
  t2 = Time.now
  compression_time = (t2 - t1).round(2)
  print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
end


def decode_huffman(input_filename, output_filename=nil)
  if output_filename == nil
    output_filename = input_filename.split('.huf')[0]+'a'
  end
  t1 = Time.now
    compressed_size = File.size(input_filename)*8
    Decode.run(input_filename,output_filename)
    raw_size = File.size(output_filename)*8
  t2 = Time.now
  compression_time = (t2 - t1).round(2)
  print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
end

if @state == 'encode'
  encode_huffman(input_filename, output_filename)
elsif @state == 'decode'
  decode_huffman(input_filename, output_filename)
end
