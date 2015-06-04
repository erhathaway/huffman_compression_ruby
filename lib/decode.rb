require 'pry'


def sort_objects(list)
	list = list.sort_by {|object| object.frequency}
	list
end


class Decode
	def self.read(file_in)
  		bin = File.binread(file_in)
  		bin.unpack('B*')
	end
	def self.decode(binary, huffman_tree)
		puts binary[0..20]
		data = ""
		head = sort_objects(huffman_tree)[-1]
		node = head
		counter = 0
		# while binary.length > 0
		bit = binary.shift
		while counter < 50000

			counter +=1

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
				node = huffman_tree.select{|obj| obj.symbol == child}[0]
			end
		end
		puts data
	end
end
	# def self.count_frequency(data)
	#   frequency = Hash.new(0)
	#   data.each{|item| frequency[item]+=1}
	#   frequency
	# end

	# def self.compress(file)
	# 	f = File.open(file, "r").read
 #  		split_data = self.split_data(f,'')
 #  		# print 'Counting symbol frequency...'
	#   	freq_data = count_frequency(split_data)
	#     # print 'Bullding Huffman Tree...'
	#   	data = HuffmanTree.new(freq_data)
	#   	data.run
	#     # print 'Maping binary data to symbols in file...'
	#    	dic = data.result_hash
	#   	compressed_data = split_data.map{|x| dic[x]}
	#     # print 'Preparing data for binary storage...'
	#   	final_compressed_data = []
	#     # print '...joining array items'
	#   	compressed_string = compressed_data.join("")
	#     final_compressed_data << compressed_string #.slice!(0..-1)
	#   	final_compressed_data
	# end
	# def self.write(compressed_data, output_filename)
	#   # print 'Writing to file...'
	#   b = compressed_data.pack('B*'*compressed_data.size)
	#   File.write(output_filename, b)
	# end
	# def self.run(in_file, out_file)
	# 	compressed_data = self.compress(in_file)
	# 	write(compressed_data, out_file)
	# end
# end

