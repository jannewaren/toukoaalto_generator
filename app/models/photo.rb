class Photo < ActiveRecord::Base
  require 'securerandom'
  scope :popular, -> { order('views').last(4) }

  # use secrect_id in url instead of id
  def to_param
    secret_id
  end

  # texts and positions
  STARTS = ['Äänestän Toukoa, koska ','Tuen Toukoa, koska ', 'Kannatan Toukoa, koska ']
  POSITION_1 = '+78+25'
  POSITION_2 = '+78+70'
  POSITION_3 = '+78+115'
  POSITION_4 = '+190+160'
  POSITION_5 = '+190+205'
  POSITION_6 = '+190+250'

  # mogrify options
  IMAGE_FILE = 'aalto15-fb-cover-no-text.jpg'
  GRAVITY = 'Northwest'
  SIZE = '40'
  FONT = 'Exo-Regular-Italic'
  COLOR = '#2e2e2e'

  # word wrap options
  ROW_1_START = 0
  ROW_1_END = 10
  ROW_2_START = 10
  ROW_2_END = 34
  ROW_3_START = 34
  ROW_3_END = 54
  ROW_4_START = 54
  ROW_4_END = 62
  ROW_5_START = 62
  ROW_5_END = 70
  ROW_6_START = 70
  ROW_6_END = 86  #a little more to fit in the last word

  # Master method to really create the image and control workflow
  def addtext(url)
    img = MiniMagick::Image.open(IMAGE_FILE)
    rows = split_text_into_rows(text)
    addrow(img, rows[0], POSITION_1)
    addrow(img, rows[1], POSITION_2)
    addrow(img, rows[2], POSITION_3)
    addrow(img, rows[3], POSITION_4)
    addrow(img, rows[4], POSITION_5)
    addrow(img, rows[5], POSITION_6)
    save_to_file(img, url)
  end

  def split_text_into_rows(text)
    words = text.split(' ')
    counter = 0
    rows = Array.new
    row1 = Array.new
    row2 = Array.new
    row3 = Array.new
    row4 = Array.new
    row5 = Array.new
    row6 = Array.new

    # add the starting phrase to first row
    start.split(' ').each do |s|
      row1 << s.to_s
    end

    words.each do |w|
      counter = counter + w.to_s.length + 1
      if counter >= ROW_1_START and counter < ROW_1_END
        row1 << w.to_s
      elsif counter >= ROW_2_START and counter < ROW_2_END
        row2 << w.to_s
      elsif counter >= ROW_3_START and counter < ROW_3_END
        row3 << w.to_s
      elsif counter >= ROW_4_START and counter < ROW_4_END
        row4 << w.to_s
      elsif counter >= ROW_5_START and counter < ROW_5_END
        row5 << w.to_s
      elsif counter >= ROW_6_START and counter < ROW_6_END
        row6 << w.to_s
      end
      puts 'word: ' + w.to_s
      puts 'counter: ' + counter.to_s
    end

    rows << row1
    rows << row2
    rows << row3
    rows << row4
    rows << row5
    rows << row6
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

  def save_to_file(img, url)
    img.write 'public'+url
  end

  def starts
    STARTS
  end

  def add_to_view_count(amount)
    if Photo.exists?(slug: slug)
      otherphoto = Photo.find_by_slug(slug)
      otherphoto.views = otherphoto.views + amount
      otherphoto.save
    else
      self.views = views + amount
    end
  end

end
