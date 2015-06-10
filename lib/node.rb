class Node
	attr_accessor :parent, :left_child, :right_child, :binary_value
	attr_reader :level, :symbol, :frequency
	
	def initialize(symbol, frequency, level=0)
		@symbol = symbol
		@frequency = frequency
		@level = level
	end

end