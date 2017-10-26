
=begin
Consider a nxm matrix, with elements decimal digits (natural numbers between 1 and 9), representing colors.
A connected set associated to an element is the set of elements that may be reached from this element,
by successive moves on a same row or column preserving the same color.
It is to determine the size and the colour of the biggest connected set. In case of multiple solutions, display them all.
=end

def collect_square_matches(nxm, numbers_in_matrix)
  <<-DOC
  Gets a dictionary of dictionaries mapping colours to a dictionary containing their corresponding 
  coordinates along with their adjacents, by colour we mean a number ranging between 0-9
  DOC
  colour_spots = {}
  numbers_in_matrix.each {|colour| colour_spots[colour] = find_colour_spots(nxm, colour)}
end

def find_squares_with_colour(nxm, colour)
  <<-DOC
  Returns an array containing all x, y coordinates in the matrix where a certain colour can be found
  DOC
  colour_found_at = Array.new([]) #Contains all coordinates where a certain colour can be found
  nxm.each_index do |y|
    nxm[y].each_index do |x|
      colour_found_at << [y, x] if nxm[y][x] == colour
    end
  end
  colour_found_at
end

def find_colour_spots(nxm, colour)

end

def determine_coordinate_position(nxm, coordinate)
  at_top, at_bottom, at_right_edge, at_left_edge = false, false, false, false
  top_right, top_left, bottom_right, bottom_left = false, false, false, false
  y, x = coordinate[0], coordinate[1]
  n_dimension = nxm[0].length - 1
  m_dimension = nxm.length - 1 #This way we avoid having an ugly and necessary - 1 for the comparisons
  at_top = true if(y == 0)
  at_bottom = true if(y == m_dimension)
  at_right_edge = true if(x == n_dimension)
  at_left_edge = true if(x == 0)
  #We now proceed to find whether our coordinate lays at any of the corners
  top_right = true if(at_top and x == n_dimension)
  top_left = true if(at_top and x == 0)
  bottom_right = true if(at_bottom and x == n_dimension)
  bottom_left = true if(at_bottom and x == 0)
  coordinate_position = {:at_edge => [at_top, at_bottom, at_right_edge, at_left_edge], :at_corner => [top_right, top_left, bottom_right, bottom_left]}
end

def towards_right(nxm, position_at)
  matches = Array.new([])
  n_dimensions = nxm[0].length - 1
  y, x = position_at[0] , position_at[1]
  colour = nxm[y][x]
  loop do
    x += 1
    if nxm[y][x] != colour or x == n_dimensions
       matches << [y, x] if nxm[y][x] == colour
      return matches
    end
    matches << [y, x]
  end
end

def towards_left(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  colour = nxm[y][x]
  loop do
    x -= 1
    if nxm[y][x] != colour or x == 0
       matches << [y, x] if nxm[y][x] == colour
      return matches
    end
    matches << [y, x]
  end
end

def upwards(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  colour = nxm[y][x]
  loop do
    y -= 1
    if nxm[y][x] != colour or y == 0
       matches << [y, x] if nxm[y][x] == colour
       return matches
    end
    matches << [y, x]
  end
end

def downwards(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  m_dimension = nxm.length - 1
  colour = nxm[y][x]
  loop do
    y += 1
    if nxm[y][x] != colour or y == m_dimension
       matches << [y, x] if nxm[y][x] == colour
       return matches
    end
    matches <<  [y, x]
  end
end

def top_right_diagonal(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  n_dimension = nxm[0].length - 1
  colour = nxm[y][x]
  loop do
    y -= 1
    x += 1
    if nxm[y][x] != colour or (y == 0 or x == n_dimension)
       matches << [y, x] if nxm[y][x] == colour
       return matches
    end
    matches << [y, x]
  end
end

def top_left_diagonal(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  colour = nxm[y][x]
  loop do
    x -= 1
    y -= 1
    if nxm[y][x] != colour or (y == 0 or x == 0)
       matches << [y, x] if nxm[y][x] == colour
       return matches
    end
    matches << [y, x]
  end
end

def bottom_left_diagonal(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  m_dimension = nxm.length - 1
  n_dimension = nxm[0].length - 1
  colour = nxm[y][x]
  loop do
    y += 1
    x -= 1
    if nxm[y][x] != colour or (y == m_dimension or x == 0)
      matches << [y, x] if nxm[y][x] == colour
      return matches
    end
    matches << [y, x]
  end
end

def bottom_right_diagonal(nxm, position_at)
  matches = Array.new([])
  y, x = position_at[0], position_at[1]
  m_dimensions = nxm.length - 1
  colour = nxm[y][x]
  loop do
    y += 1
    x += 1
    if nxm[y][x] != colour or (y == m_dimensions or x == n_dimensions)
       matches << [y, x] if nxm[y][x] == colour
       return matches
    end
    matches << [y, x]
  end
end

def compute_matches_from_corner(nxm, which_corner)
  <<-DOC
  Computes adjacent blocks with same colour/number in an nxm matrix
  We can understand the multiple directions better 
  by imagining a clock ticking but in this case we will only cover one of the quarters
  DOC
  top_right, top_left, bottom_left, bottom_right = which_corner[:at_corner][0], which_corner[:at_corner][1], which_corner[:at_corner][2], which_corner[:at_corner][3]
  position_at = [0, nxm[0].length - 1] if top_right
  position_at = [0, 0] if top_left
  position_at = [nxm.length - 1, 0] if bottom_left
  position_at = [nxm.length - 1, nxm[0].length - 1] if bottom_right
  return (upwards(nxm, position_at) << top_right_diagonal(nxm, position_at) << towards_right(nxm, position_at)).flatten! if bottom_left #First try first quarter
  return (towards_right(nxm, position_at) << bottom_right_diagonal(nxm, position_at) << downwards(nxm, position_at)).flatten! if top_left #Secondly try second quarter
  return (downwards(nxm, position_at) << bottom_left_diagonal(nxm, position_at) << towards_left(nxm, position_at)).flatten! if top_right #Thirdly try third quarter
  return (towards_left(nxm, position_at) << top_left_diagonal(nxm, position_at) <<  upwards(nxm, position_at)).flatten! if bottom_right #Last, go for the fourth quarter
end

def compute_matches_from_edge(nxm, what_edge, position_at)
  <<-DOC
  Computes adjacent blocks with same colour/number in an nxm matrix 
  We can understand the mutliple directions better  
  by imagining a clock ticking except in this case we will only cover half an hour
  DOC
  top_edge, bottom_edge, right_edge, left_edge = what_edge[:at_edge][0], what_edge[:at_edge][1], what_edge[:at_edge][2], what_edge[:at_edge][3]
  return (towards_right(nxm, position_at) << bottom_right_diagonal(nxm, position_at) << downwards(nxm, position_at) <<
      bottom_right_diagonal(nxm, position_at)).flatten! if top_edge #Twelve o' clock
  return (upwards(nxm, position_at) << top_left_diagonal(nxm, position_at) << towards_left(nxm, position_at) <<
      bottom_left_diagonal(nxm, position_at) << downwards(nxm, position_at)).flatten! if right_edge #Three o' clock
  return (towards_left(nxm, position_at) << top_left_diagonal(nxm, position_at) <<
      upwards(nxm, position_at) << top_right_diagonal(nxm, position_at) << towards_right(nxm, position_at)).flatten! if bottom_edge #Six o' clock
  return (upwards(nxm, position_at) << top_right_diagonal(nxm, position_at) << towards_right(nxm, position_at) << bottom_right_diagonal(nxm, position_at) <<
  downwards(nxm, position_at)).flatten! if left_edge #Nine o' clock

end

def compute_matches_from_center(nxm, position_at)
  <<-DOC
  Computes adjacent blocks with same colour/number in an nxm matrix 
  We can understand the multiple directions better 
  by imagining a clock ticking except in this case we will cover the whole hour
  DOC
  matches = (upwards(nxm, position_at) << top_right_diagonal(nxm, position_at) << towards_right(nxm, position_at) <<
      bottom_right_diagonal(nxm, position_at) << downwards(nxm, position_at) <<
      bottom_left_diagonal(nxm, position_at) << towards_left(nxm, position_at)).flatten!
  matches
end

def find_adjacent_matches(nxm, coordinate)
  matches = Array.new([])
  coordinate_at = determine_coordinate_position(nxm, coordinate)
  at_corner = coordinate_at[:at_corner].any?
  only_at_edge = !at_corner
  at_center = !only_at_edge && !at_corner
  if at_center
    matches = compute_matches_from_center(nxm, coordinate)
  else
    matches = compute_matches_from_edge(nxm, coordinate_at, coordinate) if only_at_edge
    matches = compute_matches_from_corner(nxm, coordinate_at) if at_corner
  end
  matches
end

def what_numbers_in_matrix(nxm)
  <<-DOC
  Returns integers ranging between 0-9 that are contained in an nxm matrix
  DOC
  numbers = Array.new([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  numbers_in_matrix = Array.new([])
  nxm.each {|vector| vector.each {|coordinate| numbers_in_matrix << coordinate if numbers.include? coordinate unless numbers_in_matrix.include? coordinate}}
  numbers_in_matrix
end

nxm = [[1, 5], [5, 5], [5, 9]]

numbers_in_matrix = what_numbers_in_matrix(nxm)
squares_with_colour_5 = find_squares_with_colour(nxm, 5)
adjacent_matches_for_5 = find_adjacent_matches(nxm, [1, 0])

puts adjacent_matches_for_5
