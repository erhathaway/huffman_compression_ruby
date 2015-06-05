require 'pry'


def sort_objects(list)
	list = list.sort_by {|object| object.frequency}
	list
end


class Decode
	def self.read(file_in)
  		bin = File.binread(file_in)
  		bin.unpack('B*')[0].split("")
	end
	def self.decode(binary, huffman_tree)
		symbol_hash = {}
		huffman_tree.each{|obj| symbol_hash[obj.symbol]=obj}

		data = ""
		head = sort_objects(huffman_tree)[-1]
		node = head

		bit = binary.shift
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

	def self.run(file_in, file_out, huffman_tree)
		binary = read(file_in)
		data = decode(binary, huffman_tree)
		write(data,file_out)
	end
end