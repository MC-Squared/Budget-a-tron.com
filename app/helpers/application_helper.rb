module ApplicationHelper
  def nav_bar_brand
    content_tag :span do
      concat image_tag 'logo-white.svg', class: 'nav-logo'
      concat 'Budget-a-tron'
    end
  end
end
