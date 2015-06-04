require_relative "../../lib/run"
require_relative "../../lib/node"
require_relative "../../lib/encode"
require_relative "../../lib/huffman_tree"

describe Node do
	let (:new_node){new_node = Node.new('a',5)}
	describe "#initialize" do
		it "imports a symbol" do
			expect(new_node.symbol).to eq('a')
		end
		it "imports a frequency value" do
			expect(new_node.frequency).to eq(5)
		end
	end
	context "set parent, children, and binary value" do
		it "and check parent value" do
			new_node.parent = 'id_1'
			expect(new_node.parent).to eq('id_1')
		end
		it "and check child values" do
			new_node.left_child = 'b'
			new_node.right_child = 'z'
			expect(new_node.left_child).to eq('b')
			expect(new_node.right_child).to eq('z')
		end
		it "and binary value string" do
			new_node.binary_value = '01001'
			expect(new_node.binary_value).to eq('01001')
		end
	end 
end


describe HuffmanTree do
	let (:frequency_values){frequency_values={"c"=>1, "a"=>2, "t"=>3, " "=>2, "m"=>1, "o"=>3, "u"=>5, "s"=>3, "e"=>3}}
 	let (:huffman_tree){huffman_tree=HuffmanTree.new(frequency_values)}
 	describe "#initialize" do
 		it "imports a hash of symbol:frequency values" do
 			expect(huffman_tree.init_freq_values.class).to eq(Hash)
 		end
 		it "makes a node object for each hash item" do
 			expect(huffman_tree.frequency_objects[0].class).to eq(Node)
 		end
 		it "sets the node counter to 0" do
 			expect(huffman_tree.new_node_counter).to eq(0)
 		end
 		it "sets the queue equal to the frequency object array" do
 			expect(huffman_tree.queue).to eq(huffman_tree.frequency_objects)
 		end
	end
	describe "#sort_objects" do
		it "sorts a node objects array by frequency" do
			obj = huffman_tree.frequency_objects
			expect(huffman_tree.sort_objects(obj)[-1].symbol).to eq("u")
		end
	end
	describe "#make_parent" do
		describe "makes a new node" do
			it "by increasing the new node counter by 1" do
				huffman_tree.make_parent
				expect(huffman_tree.new_node_counter).to eq(1)
			end
			it "by adding the parent to the queue" do
				huffman_tree.make_parent
				expect(huffman_tree.queue[-1].symbol).to eq('id_1')
			end
			it "by adding the frequency of the children together" do
				huffman_tree.make_parent
				expect(huffman_tree.queue[-1].frequency).to eq(2)
			end
		end
	end
	describe "#build_tree" do
		describe "iterates through all objects in the queue" do
			it "and increases the node counter each time" do
				huffman_tree.build_tree
				expect(huffman_tree.new_node_counter).to eq(8)
			end
			it "and goes until the queue has only 1 object left" do
				huffman_tree.build_tree
				expect(huffman_tree.queue.length).to eq(1)
			end
			it "and adds all the new nodes to the frequency object list" do
				huffman_tree.build_tree
				expect(huffman_tree.frequency_objects.length).to eq(huffman_tree.new_node_counter + huffman_tree.init_freq_values.length)
			end
		end
	end
	describe "#assign_binary_values" do
		describe "transverse the built tree, assign binary to branches" do
			it "while preserving frequency_objects list" do
				huffman_tree.assign_binary_values
				expect(huffman_tree.frequency_objects.length).to eq(huffman_tree.new_node_counter + huffman_tree.init_freq_values.length)
			end
			# it "for left branches it assigns a 1" do
			# end
			# it "for right branches it assigns a 0" do
			# end
		end
	end


end

