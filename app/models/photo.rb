class Photo
  include ActiveModel::Model
  attr_accessor :id, :img, :start, :text, :row1, :row2, :row3, :row4, :words, :url
  require 'securerandom'

  # texts and positions
  STARTS = ['Äänestän Toukoa koska ','Tuen Toukoa koska ', 'Kannatan Toukoa koska ']
  POSITION_1 = '+78+55'
  POSITION_2 = '+78+100'
  POSITION_3 = '+190+145'
  POSITION_4 = '+220+190'

  # mogrify options
  IMAGE_FILE = 'aalto15-fb-cover-no-text.jpg'
  GRAVITY = 'Northwest'
  SIZE = '40'
  FONT = 'Exo-Regular-Italic'
  COLOR = '#2e2e2e'

  def addtext
    self.id = Time.now.to_i.to_s + '_' + SecureRandom.hex
    self.img = MiniMagick::Image.open(IMAGE_FILE)

    self.row1 = Array.new
    self.start.split(' ').each do |s|
      self.row1 << s.to_s
    end
    self.row2 = Array.new
    self.row3 = Array.new
    self.row4 = Array.new

    split_text_into_rows
    addrow(self.row1, POSITION_1)
    addrow(self.row2, POSITION_2)
    addrow(self.row3, POSITION_3)
    addrow(self.row4, POSITION_4)
  end

  def split_text_into_rows
    self.words = self.text.split(' ')
    counter = 0
    words.each do |w|
      counter = counter + w.to_s.length
      if counter > 0 and counter < 8
        self.row1 << w.to_s
      elsif counter > 8 and counter < 32
        self.row2 << w.to_s
      elsif counter > 32 and counter < 52
        self.row3 << w.to_s
      elsif counter > 52 and counter < 68
        self.row4 << w.to_s
      end
    end
  end


  def addrow(row,position)
    mogrify = MiniMagick::Tool::Mogrify.new
    mogrify.annotate(position,back_to_string(row))
    mogrify.gravity GRAVITY
    mogrify.pointsize SIZE
    mogrify.font FONT
    mogrify.fill COLOR
    mogrify << self.img.path
    mogrify.call
  end

  def back_to_string(words)
    temp = ''
    words.each do |w|
      temp = temp + w.to_s+' '
    end
    return temp
  end

  def save_to_file
    self.img.write self.id.to_s+'.jpg'
    self.url = self.id.to_s+'.jpg'
  end

  def starts
    STARTS
  end

end
