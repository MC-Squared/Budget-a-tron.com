module ApplicationHelper
  def brand_helper(image_src)
    content_tag :span do
      concat image_tag image_src, class: 'nav-logo'
      concat content_tag :i, 'Budget-a-tron'
    end
  end

  def nav_bar_brand
    brand_helper 'logo-white.svg'
  end

  def footer_brand
    brand_helper 'logo-black.svg'
  end

  def currency_color_class(amount)
    amount < 0 ? 'currency-negative' : 'currency-positive'
  end
end
