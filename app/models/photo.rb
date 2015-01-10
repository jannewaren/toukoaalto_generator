class Photo
  include ActiveModel::Model
  attr_accessor :start, :text, :url
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

  # word wrap options
  ROW_1_START = 0
  ROW_1_END = 8
  ROW_2_START = 8
  ROW_2_END = 32
  ROW_3_START = 32
  ROW_3_END = 50
  ROW_4_START = 50
  ROW_4_END = 64

  # Master method to really create the image and control workflow
  def addtext
    randomid = Time.now.to_i.to_s + '_' + SecureRandom.hex
    img = MiniMagick::Image.open(IMAGE_FILE)

    rows = split_text_into_rows(self.text)
    addrow(img, rows[0], POSITION_1)
    addrow(img, rows[1], POSITION_2)
    addrow(img, rows[2], POSITION_3)
    addrow(img, rows[3], POSITION_4)

    save_to_file(img, randomid)
  end

  def split_text_into_rows(text)
    words = text.split(' ')
    counter = 0
    rows = Array.new
    row1 = Array.new
    row2 = Array.new
    row3 = Array.new
    row4 = Array.new

    # add the starting phrase to first row
    self.start.split(' ').each do |s|
      row1 << s.to_s
    end

    words.each do |w|
      counter = counter + w.to_s.length
      if counter >= ROW_1_START and counter < ROW_1_END
        row1 << w.to_s
      elsif counter >= ROW_2_START and counter < ROW_2_END
        row2 << w.to_s
      elsif counter >= ROW_3_START and counter < ROW_3_END
        row3 << w.to_s
      elsif counter >= ROW_4_START and counter < ROW_4_END
        row4 << w.to_s
      end
    end

    rows << row1
    rows << row2
    rows << row3
    rows << row4
    return rows
  end


  def addrow(img,row,position)
    mogrify = MiniMagick::Tool::Mogrify.new
    mogrify.annotate(position,back_to_string(row))
    mogrify.gravity GRAVITY
    mogrify.pointsize SIZE
    mogrify.font FONT
    mogrify.fill COLOR
    mogrify << img.path
    mogrify.call
  end

  def back_to_string(words)
    temp = ''
    words.each do |w|
      temp = temp + w.to_s+' '
    end
    return temp
  end

  def save_to_file(img, randomid)
    img.write 'public/images/'+randomid.to_s+'.jpg'
    self.url = '/images/'+randomid.to_s+'.jpg'
  end

  def starts
    STARTS
  end

end
