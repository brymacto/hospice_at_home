module ApplicationHelper
  def format_flash_messages(messages)
    Array(messages).join('<br>').html_safe
  end

  def formatted_created_at(object)
    "#{object.created_at.strftime('%F')} (#{distance_of_time_in_words object.created_at, Time.now} ago)"
  end
end
