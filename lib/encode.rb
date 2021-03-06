require_relative 'node'
require_relative 'huffman_tree'

require 'pry'
class Encode
	def self.read(input_file)
	f = File.open(input_file, "r").read
	end

	def self.split_symbols(data, seperator)
  		data = data.split(seperator)
	end

	def self.count_frequency(data)
		frequency = Hash.new(0)
		data.each{|item| frequency[item]+=1}
		frequency
	end

	def self.compress(symbol_freq, split_data)
		# print 'Bullding Huffman Tree...'
		data = HuffmanTree.new(symbol_freq)
		huffman_data = data.run
		# print 'Maping binary data to symbols in file...'
		frequency_dic = data.result_hash
		compressed_data = split_data.map{|x| frequency_dic[x]}
		# print 'Preparing data for binary storage...'
		final_compressed_data = []
		# print '...joining array items'
		compressed_string = compressed_data.join("")
		[compressed_string]
	end

	def self.write(symbol_freq, compressed_data, output_filename)
		# print 'Writing to file...'
		#---write header-----
		header = ""
		header_symbols = {}
		alaphabet = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
		symbol_freq.each do |k,v|
			if alaphabet.include? k.downcase 
				header_symbols[k+"$^$"]=v.to_s+"$^$"
			else
				header_symbols[k+"$^$"]=v.to_s+"$^$"
			end
		end
		# puts header_symbols

		header_symbols.map{|k,v| header += k+v.to_s}
		b = compressed_data.pack('B*'*compressed_data.size)
		File.write(output_filename, header + " --- " + b)
	end

	def self.run(in_file, out_file)

		data 		= read(in_file)
		split_data 	= split_symbols(data,'')
		symbol_freq = count_frequency(split_data)
		# print symbol_freq
		data 		= compress(symbol_freq, split_data)
		write(symbol_freq, data, out_file) # write compressed data
	end
end

