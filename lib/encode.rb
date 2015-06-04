require_relative 'node'
require_relative 'huffman_tree'

require 'pry'
class Encode

	def self.split_data(data, seperator)
  		data = data.split(seperator)
	end

	def self.count_frequency(data)
	  frequency = Hash.new(0)
	  data.each{|item| frequency[item]+=1}
	  frequency
	end

	def self.compress(file)
		f = File.open(file, "r").read
  		split_data = self.split_data(f,'')
  		# print 'Counting symbol frequency...'
	  	freq_data = count_frequency(split_data)
	    # print 'Bullding Huffman Tree...'
	  	data = HuffmanTree.new(freq_data)
	  	huffman_data = data.run
	    # print 'Maping binary data to symbols in file...'
	   	frequency_dic = data.result_hash
	  	compressed_data = split_data.map{|x| frequency_dic[x]}
	    # print 'Preparing data for binary storage...'
	  	final_compressed_data = []
	    # print '...joining array items'
	  	compressed_string = compressed_data.join("")
	    final_compressed_data << compressed_string #.slice!(0..-1)
	  	[final_compressed_data, huffman_data]
	end
	def self.write(compressed_data, output_filename)
	  # print 'Writing to file...'
	  b = compressed_data.pack('B*'*compressed_data.size)
	  File.write(output_filename, b)
	end
	def self.run(in_file, out_file)
		data = self.compress(in_file)
		write(data[0], out_file) # write compressed data
		data[1] # huffman data
	end
end

