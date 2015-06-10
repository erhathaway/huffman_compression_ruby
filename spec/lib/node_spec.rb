require_relative "../../lib/encode"

describe Node do
	let (:new_node){new_node = Node.new('a',5)}
	describe "#initialize" do
		it "imports a symbol" do
			expect(new_node.symbol).to eq('a')
		end
		it "imports a frequency value" do
			expect(new_node.frequency).to eq(5)
		end
		it "imports a level where the node exists on the tree" do
			expect(new_node.level).to eq(0)
			new_node = Node.new('a',5,2)
			expect(new_node.level).to eq(2)	
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
