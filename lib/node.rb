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