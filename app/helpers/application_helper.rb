module ApplicationHelper
  def format_flash_messages messages
    Array(messages).join("<br>").html_safe
  end
end
