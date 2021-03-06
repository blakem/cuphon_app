module ApplicationHelper
  # Return a title on a per-page basis
  def title
    base_title = "Cuphon Controlpanel"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "Cuphon", :class => "round")
  end
end
