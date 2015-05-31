# YOUR CODE GOES HERE
require 'pry'
require 'bindata'


@huf
@tran
# split file by seperator
def split_data(data, seperator)
  data = data.split(seperator)
end

# returns a frequency hash (key = item, value = frequency)
def count_frequency(data)
  frequency = Hash.new(0)
  data.each{|item| frequency[item]+=1}
  puts
  print "...unique symbols: ", frequency.length
  puts
  frequency
end

# order frequency hash by value
def order_frequency_hash(data)
  data.sort_by {|k,v| v}
end

# order frequency array by second item
def order_frequency_array(data)
  data.sort_by {|a| a[1]}
end

#accepts an array consisting of two children (each an array)
#each child is: id, frequency, [child1, child2]
def node_maker(child_container, counter)
    parent = []
    parent[0] = 'id_'+counter.to_s                                  # [0] = id
    parent[1] = child_container[0][1]+child_container[1][1]         # [1] = frequency
    parent[2] = [child_container[0][0], child_container[1][0]]      # [2] = [child1, child2]
    return parent
end

# creates a huffman tree of frequency data hash { symbol : frequency}
def tree_maker(frequency_data)
  leaf_counter  = 0 # for testing
  node_counter  = 0 # for testing
  counter       = 1 # for auto incrementing node IDs
  huffman_tree  = []
  original_data = frequency_data
  queue         = frequency_data

  while queue.length > 1

    child_container = []
    # take two nodes/leafs off queue
    while child_container.length < 2
      queue = order_frequency_array(queue)
      child = queue.shift

      # check whether leaf or node
      if original_data.include? child
        leaf_counter +=1 # for testing
        child[2]= NilClass
      else
        node_counter +=1
      end

      child_container << child
      huffman_tree << child
    end
    node = node_maker(child_container, counter)
    queue << node
    counter +=1

    # if last item in frequency data, make sure you save it to the huffman tree!
    if queue.length == 1
      huffman_tree << node
      node_counter +=1
    end
  end
  puts
  print "...nodes: ", node_counter
  puts
  print "...leafs: ", leaf_counter
  @huf = huffman_tree
  huffman_tree
end

# transverses the frequency tree and assigns binary digits to nodes/leafs
def huffman_data (huffman_tree)
  number = []
  transversed_tree = Hash.new(0)
  parent = huffman_tree[-1]
  transversed_tree[parent[0]]=''
  queue = [parent[0]]
  count = 0
  while count <= huffman_tree.length
    y = queue.shift
    number << y

    # find child
    huffman_tree.each do |x|
      if x[0] == y
        parent = x
      end
    end

    unless parent[2] == NilClass
      transversed_tree[parent[2][0]]= '1' + transversed_tree[parent[0]].to_s 
      transversed_tree[parent[2][1]]= '0' + transversed_tree[parent[0]].to_s 
      queue << parent[2][0]
      queue << parent[2][1]
    end
    count +=1
  end
  puts
  print '...binary assigned symbols: ', transversed_tree.length
  puts
  @tran = transversed_tree.invert
  transversed_tree
end

def huffman_encoding(file)
  f = File.open(file, "r").read

  split_data = split_data(f,'')
  print split_data[0,5]
    print 'Counting symbol frequency...'
  data = count_frequency(split_data)
    print '...success'
    puts
    print 'Ordering symbols by frequency...'
  data = order_frequency_hash(data)
    puts
    print '...success'
    puts
    print 'Building huffman tree...'
  huffman_tree = tree_maker(data)
    puts
    print '...success'
    puts
    print 'Assigning binary numbers...'
  transversed_tree = huffman_data(huffman_tree)
    print '...success'
    puts
    print 'Maping binary data to symbols in file...'
  compressed_data = split_data.map{|x| transversed_tree[x]}
    puts
    print '...success'
    puts
    print 'Preparing data for binary storage...'
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

def decompress(input_filename, output_filename)
  t1 = Time.now
  raw_size = File.size(input_filename)*8
  result = huffman_encoding(input_filename)
  write_file(result, output_filename)
  compressed_size = File.size(output_filename)*8
  t2 = Time.now
  compression_time = (t2 - t1).round(2)
  print_result(input_filename, output_filename, raw_size, compressed_size, compression_time)
end
compress("moby_dick.txt","gold_fish.txt")

