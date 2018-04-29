module PagesHelper
  def howto_list_item(number, verb, link_text, path, done)
    prefix = "#{number}. #{verb.titleize} "
    if user_signed_in?
      if done
        content_tag :div do
          concat check_icon
          concat (content_tag :span, class:'strikethrough' do
            concat prefix
            concat link_text
          end)
        end
      else
        content_tag :div do
          concat uncheck_icon
          concat prefix
          concat link_to(link_text, path)
        end
      end
    else
      content_tag :div, prefix + link_text
    end
  end

  def howto_list_resource(number, verb, resource, path)
    resource_text = "#{resource.to_s.humanize.downcase}"
    done = user_signed_in? && current_user.send(resource).count > 0
    howto_list_item(number, verb, resource_text, path, done)
  end

  private

    def check_icon
      content_tag :span, nil,
        class:'howto-icon checked', 'data-feather': 'check-square'
    end

    def uncheck_icon
      content_tag :span, nil,
        class:'howto-icon', 'data-feather': 'square'
    end
end
