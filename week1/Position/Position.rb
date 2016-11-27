# CHESSBOARD = (:a1..:h8).grep(/[a-h][1-8]/)
# position = Position.new(a1: :black_queen, e2: :white_queen, h5: :white_bishop)
# CHESSBOARD.map(&position).to_h # => {a1: :black_queen, a2: :empty, a3: :empty, ...}
# CHESSBOARD.select(&position.occupied) # => [:a1, :e2, :h5]
# CHESSBOARD.select(&position.occupied(:queen)) # => [:a1, :e2]

class Position
  def initialize(placed_items)
    @placed_items = placed_items
  end

  def to_proc
    proc { |place| [place, @placed_items.fetch(place, :empty)] }
  end

  def occupied(item = nil)
    item ? proc { |place| @placed_items[place].to_s.include? item.to_s } : @placed_items
  end
end
