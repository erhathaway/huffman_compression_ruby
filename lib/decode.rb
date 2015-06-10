require 'pry'
require_relative 'huffman_tree'

def sort_objects(list)
	list = list.sort_by {|object| object.frequency}
	list
end

class Decode
	def self.read(file_in)
  		file 			= File.binread(file_in)
  		file_contents 	= file.split(" --- ")
  		file_header 	= file_contents[0]
  		file_data 		= file_contents[1].unpack('B*')[0].split("")

  		symbol_list = file_header.split("$^$")
		counter=0
		symbol_freq = {}
		while counter < symbol_list.length
			symbol = symbol_list[counter]
			frequency = symbol_list[counter+1]
			symbol_freq[symbol]=frequency.to_i
			counter +=2
		end
		# print symbol_freq
		[symbol_freq, file_data]
	end
	def self.decode(freq_hash, binary)
		ht = HuffmanTree.new(freq_hash)

		huffman_tree = ht.run
		symbol_hash = {}
		huffman_tree.each{|obj| symbol_hash[obj.symbol]=obj}

		data = ""
		head = symbol_hash['head']
		node = head
		bit = 'start'

		while binary.length > 0
			if node.left_child == nil && node.right_child == nil
				data += node.symbol
				node = head
			else
				bit = binary.shift
				if bit == '1'
					child = node.left_child
				else
					child = node.right_child
				end
				node = symbol_hash[child]
			end
		end
		data
	end

	def self.write(data, file_out)
		File.write(file_out, data)
	end

	def self.run(file_in, file_out)
		file_contents = read(file_in)
		header = file_contents[0]
		bin = file_contents[1]
		data = decode(header, bin)
		write(data,file_out)
	end
end