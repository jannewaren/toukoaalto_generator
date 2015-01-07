module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | ToukoaaltoGenerator"      
    end
  end
end
