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

  def flash_type_to_class(flash_type)
    case flash_type
    when 'notice'
      'success'
    when 'alert'
      'danger'
    else
      'info'
    end
  end
end
