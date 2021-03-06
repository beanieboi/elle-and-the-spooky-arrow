class Screen
  NINE_BITS =  /........./
  EIGHT_BITS = /......../

  def initialize(panels = 4, width = 8, height = 9)
    @width = width
    @height = height
    @panels = panels
    @screen = [ Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false),
                Array.new(@panels * @width, false)]

    @blank_screen = Marshal.dump(@screen)
    @blink_bit = "1"
  end

  def height
    @height
  end

  def width
    @panels * @width
  end

  def col(col, value)
    @screen.each { |row| row[col]= value}
  end

  def row(row, value)
    @screen[row].map! { |p| p = value}
  end

  def shift_cols
    @screen.each { |row| row << row.shift }
  end

  def shift_rows
    @screen << @screen.shift
  end

  def []=(row, col, value)
    @screen[col][row] = value
  end

  # convert to bit stream
  def ascii_bit_stream
    s = ""
    0.upto((@panels * @width)-1) do |col|
      @screen.each do |row|
        s << (row[col] ? "1" : "0")
      end
    end
    s
  end

  def ascii_bit_stream2
    s = ""
    0.upto((@panels * @width)-1) do |col|
      s << @blink_bit
      @screen.each do |row|
        s << (row[col] ? "1" : "0")
      end
    end
    s
  end

  # add blink bit (first bit)
  def ascii_bit_stream_with_blink
    ascii_bit_stream.scan(NINE_BITS).map { |b| (@blink_bit + b) }.join("")
  end

  def bit_stream
    ascii_bit_stream_with_blink.scan(EIGHT_BITS).map { |b| b.to_i(2) }
  end

  def reset
    @screen = Marshal.load(@blank_screen)
  end
end
