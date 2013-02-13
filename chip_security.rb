class Array
  alias start_color first
  alias end_color last
end

def possible(chips, start_color, end_color)
  if chips.length == 1 then
    chip = chips[0]
    if chip.start_color == start_color and chip.end_color == end_color
      return true
    else
      return false
    end
  end

  chips.each do |chip|
    if chip.start_color == start_color then
      return true if possible(chips - [chip], chip.end_color, end_color)
    end
  end

  return false
end

chips = [[:blue,    :green],
         [:green,   :blue]]
         # [:green,   :red],
         # [:red,     :purple],
         # [:purple,  :green]]

puts possible(chips, :blue, :blue)
