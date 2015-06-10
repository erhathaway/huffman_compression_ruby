require 'pry'
require_relative 'node'

class HuffmanTree
	attr_reader :init_freq_values, :frequency_values, :frequency_objects, :queue, :new_node_counter

	def initialize(frequency_values)
		@init_freq_values = frequency_values
		#create a node for each symbol in the frequency values list
		@frequency_objects = []
		frequency_values.each{|k,v| @frequency_objects << Node.new(k,v) }
		#the queue is used for generating the huffman tree
		@queue = @frequency_objects
		#used for naming non-leaf nodes
		@new_node_counter = 0
	end

	def sort_objects(list)
		list = list.sort_by {|object| object.frequency}
		# list
	end

	def make_parent(queue=@queue, huffman_tree=@frequency_objects, parent_name=@new_node_counter)
		if queue.length > 1
			queue = sort_objects(queue)
			@new_node_counter +=1
			#take lowest frequency symbol objs off queue
			left_child  = queue.shift
			right_child = queue.shift
			#create new parent node name
			if queue.length == 0
				parent_id = 'head'
			else
				parent_id = 'id_'+new_node_counter.to_s
			end

			#calc level of node based on children
			if left_child.level >= right_child.level
				level = left_child.level + 1
			else 
				level = right_child.level + 1
			end

			#crate parent new(name, frequency sum)
			parent = Node.new(parent_id, left_child.frequency+right_child.frequency, level)
			#store name of children in parent
			parent.left_child = left_child.symbol
			parent.right_child= right_child.symbol
			#store name of parent in children
			left_child.parent = parent_id
			right_child.parent = parent_id
			#add parent to queue and frequency_objects
			queue << parent
			@queue = queue
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
		@frequency_objects = sort_objects(@frequency_objects)
		head = @frequency_objects[-1]
		head.binary_value = ''
		queue = [head]
		while queue.length > 0
			parent = queue.pop
			unless parent.left_child == nil
				left_node = @frequency_objects.select{|obj| obj.symbol == parent.left_child}[0]
				left_node.binary_value = parent.binary_value + '1'
				queue << left_node
			end
			unless parent.right_child == nil
				right_node = @frequency_objects.select{|obj| obj.symbol == parent.right_child}[0]
				right_node.binary_value = parent.binary_value + '0'
				queue << right_node
			end
		end
	end

	def run
		assign_binary_values
		@frequency_objects
	end

	def result_hash
		result_hash = {}
		@frequency_objects.each{|obj| result_hash[obj.symbol]=obj.binary_value}
		result_hash
	end
end