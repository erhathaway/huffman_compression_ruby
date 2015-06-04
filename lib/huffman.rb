require 'pry'

def split_data(data, seperator)
  data = data.split(seperator)
  data.each {}
end

def count_frequency(data)
  frequency = Hash.new(0)
  # nodes = []
  data.each{|item| frequency[item]+=1}
  # frequency.each{|k,v| nodes << Node.new(k,v)}
  # binding.pry
  puts
  print "...unique symbols: ", frequency.length
  puts
  # nodes
  frequency
end

class Node
	attr_accessor :parent, :left_child, :right_child, :binary_value
	def initialize(symbol, frequency)
		@symbol = symbol
		@frequency = frequency
	end
	def symbol
		@symbol
	end
	def frequency
		@frequency
	end
end


class HuffmanTree
	attr_reader :init_freq_values, :frequency_values, :frequency_objects, :queue, :new_node_counter
	attr_reader :init_freq_values

	def initialize(frequency_values)
		@init_freq_values = frequency_values
		@frequency_objects = []
		# binding.pry
		frequency_values.each{|k,v| @frequency_objects << Node.new(k,v) }
		# binding.pry
		@queue = @frequency_objects
		@new_node_counter = 0
	end

	def init_size
		@init_freq_values.length
	end

	def sort_queue
		@queue = @queue.sort_by {|object| object.frequency}
	end

	def sort_frequency_objects
		@frequency_objects = @frequency_objects.sort_by {|object| object.frequency}
	end

	def make_parent
		sort_queue
		@new_node_counter +=1
		left_child  = @queue.shift
		right_child = @queue.shift
		unless right_child == nil || left_child == nil
			# binding.pry
			parent_id = 'id_'+new_node_counter.to_s
			parent = Node.new(parent_id, left_child.frequency+right_child.frequency)
			parent.left_child = left_child.symbol
			parent.right_child= right_child.symbol
			left_child.parent = parent_id
			right_child.parent = parent_id
			@queue << parent
			@frequency_objects << parent
		end
	end

	def build_tree
		while @queue.length > 1
			make_parent
		end
	end

	def assign_binary_values
		build_tree
		sort_frequency_objects
		head = @frequency_objects[-1]
		head.binary_value = ''
		queue = [head]
		while queue.length > 0
			# binding.pry
			parent = queue.pop
			unless parent.left_child == nil
				left_node = @frequency_objects.select{|obj| obj.symbol == parent.left_child}[0]
				left_node.binary_value = '1' + parent.binary_value
				queue << left_node
			end
			unless parent.right_child == nil
				right_node = @frequency_objects.select{|obj| obj.symbol == parent.right_child}[0]
				right_node.binary_value = '0' + parent.binary_value
				queue << right_node
			end
		end
	end

	def result
		assign_binary_values
		@frequency_objects
	end

	def result_hash
		result_hash = {}
		@frequency_objects.each{|obj| result_hash[obj.symbol]=obj.binary_value}
		result_hash
	end
end


def huffman_encoding(file)
  f = File.open(file, "r").read

  split_data = split_data(f,'')
  # print split_data[0,5]
    print 'Counting symbol frequency...'
  freq_data = count_frequency(split_data)
    print '...success'
    puts
    print 'Bullding Huffman Tree...'
  data = HuffmanTree.new(freq_data)
  data.result
    puts
    print '...success'
    puts
    print 'Maping binary data to symbols in file...'
   	dic = data.result_hash
        # binding.pry

  compressed_data = split_data.map{|x| dic[x]}
    puts
    print '...success'
    puts
    print 'Preparing data for binary storage...'
    # binding.pry
  final_compressed_data = []
    puts
    print '...joining array items'
  compressed_string = compressed_data.join("")
    puts
    # print '...slicing string in 8 bit segments'
    # puts
  # while compressed_string.length > 0
    # binding.pry
    final_compressed_data << compressed_string #.slice!(0..-1)
  # end
    print '...success'
    puts
  final_compressed_data
end

def print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
  puts "-"*50
  puts "Original file name: \t : #{input_filename}"
  puts "Compressed file name: \t : #{output_filename}"
  puts "Original file size: \t : #{raw_size} bytes"
  puts "Compressed file size: \t : #{compressed_size} bytes"
  puts "Compression took: \t : #{compression_time} seconds"
  compression_ratio=raw_size.to_f/compressed_size.to_f
  puts "Compressed file is: \t : #{((1-(compression_ratio**(-1))).round(2)*100).to_i} % smaller"
  puts "Compression ratio: \t : #{compression_ratio.round(2)} x"
  puts "-"*50
end


# 1) takes an array where each item is 8 bits of binary digits.
# 2) compresses these digits into a string of binary
# 3) writes the string to a file
def write_file(compressed_data, output_filename)
  print 'Writing to file...'
  b = compressed_data.pack('B*'*compressed_data.size)
  File.write(output_filename, b)
  puts
  print '...success'
  puts
end

def compress(input_filename, output_filename)
  t1 = Time.now
  raw_size = File.size(input_filename)*8
  result = huffman_encoding(input_filename)
  write_file(result, output_filename)
  compressed_size = File.size(output_filename)*8
  t2 = Time.now
  compression_time = (t2 - t1).round(2)
  print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
end


compress("../moby_dick.txt","gold_fish.txt")