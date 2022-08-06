# frozen_string_literal: true

class Node
    
    attr_accessor :data, :neighbors, :visited

    def initialize(data)
        @data = data
        @neighbors = []
        @visited = false
    end

    def add_edge(neighbor)
        @neighbors << neighbor
    end
end

class Graph

    attr_accessor :nodes, :path, :destination_square

    def initialize
        @nodes = []
        @destination_square = nil
        @path = []
    end

    def add_node(value)
    @nodes << Node.new(value)
    end

    def get_node(data)
        @nodes.each_with_index do |n, idx|
            if data == n.data
                return n
            end
        end
    end

    def get_idx(data)
        @nodes.each_with_index do |n, idx|
            if data == n.data
                return idx
            end
        end
    end

    def get_edge(data)
        start = @nodes[get_idx(data)]
        edge = start.neighbors[0].data
        return edge
    end
    def traverse_bfs(starting_square, destination_square)
        
        @destination_square = destination_square
        moves = 0
        edge = get_edge(starting_square)
        until @path.include?(edge) # until path include an edge of starting square 
            root = @nodes[get_idx(starting_square)]
            queue = []
            queue << root
            path.unshift(@destination_square)
            @nodes.each do |node|
                node.visited = false
            end
            bfs(queue)
            moves += 1
        end
        puts "You made it in #{moves} moves!"
        p starting_square
        @path.each { |a| p a }
    end
    
    def bfs(queue)
        array = []
        while !(queue.empty?)
            current = queue[0]
            if !(current.visited)
            
                current.visited = true
                current.neighbors.each do |neighbor|
                    queue << neighbor if !(neighbor.visited)
                end
                array << current.data
                current.neighbors.each do |neighbor|
                    if neighbor.data == @destination_square

                        @destination_square = array[-1]
                        
                        
                        
                        queue = []
                    end
                end
            end
            queue = queue[1..] if !(queue.empty?)
        end
        return 
    end

end

class Board
  def initialize
    @board = Array.new(8) { [*0..7] }
    @knight = nil
    @adjacency_list = Graph.new
    
  end
  attr_accessor :board, :array, :adjacency_list

  def knight_moves(starting_square, destination_square)
    @knight = Knight.new(self, starting_square, @board)
    # add nodes
    @board.each_with_index do |row, idx|
        row.each do |col|
            @adjacency_list.add_node([idx, col])
        end
    end

    # add edges
    @adjacency_list.nodes.each do |node|

        j = 0
        8.times do
            data = @knight.rec(node.data[0], node.data[1], j)
            if !(data == nil)
                neigh = @adjacency_list.get_node(data)    # get neighbor 
                node.add_edge(neigh)
            end
            j += 1
        end
    end
    @adjacency_list.traverse_bfs(starting_square, destination_square)
  end
  
  def display_board
    board = @board
    board.each_with_index do |row, idx|
      print "row #{idx}: #{row}\n"
    end
  end
end

class Knight
  def initialize(game, start, board)
    @game = game
    @start = start
    @board = board
  end

  def rec(row, col, j = nil)
    
    steps_row = [
        -2, 
        -2, 
        -1, 
        -1, 
        +2, 
        +2, 
        +1, 
        +1 
      ]

      steps_col = [
        -1,
        +1,
        -2,
        +2,
        -1,
        +1,
        -2,
        +2
      ]

    j = 0 if j == nil
    new_row = steps_row[j] + row
    new_col = steps_col[j] + col
    return [new_row, new_col] if (0..7).include?(new_row) && (0..7).include?(new_col)
  end
end
board = Board.new

board.display_board

board.knight_moves([3, 3], [0, 0])
