module BreadcrumbGenerator
  def load_breadcrumbs(crumb_class: nil, crumb_instance: nil, crumb_actions: [])
    @breadcrumb_links = [class_breadcrumb(crumb_class)]
    add_instance_to_breadcrumb_links(crumb_instance)

    crumb_actions.each do |crumb_action|
      @breadcrumb_links << action_breadcrumb(crumb_class, crumb_instance, crumb_action)
    end

    @breadcrumb_links
  end

  private

  def add_instance_to_breadcrumb_links(breadcrumb_instance)
    @breadcrumb_links << instance_breadcrumb(breadcrumb_instance) if breadcrumb_instance
  end

  def class_breadcrumb(breadcrumb_class)
    { path: url_for(breadcrumb_class), name: breadcrumb_class_name(breadcrumb_class) }
  end

  def instance_breadcrumb(breadcrumb_instance)
    { path: url_for(breadcrumb_instance), name: breadcrumb_instance.name }
  end

  def action_breadcrumb(breadcrumb_class, breadcrumb_instance, action)
    return match_explorer_breadcrumb if action == :match_explorer
    breadcrumb_instance_id = (breadcrumb_instance ? breadcrumb_instance.id : nil)
    { path: url_for(controller: breadcrumb_controller_name(breadcrumb_class), action: action, id: breadcrumb_instance_id), name: action.to_s.capitalize }
  end

  def match_explorer_breadcrumb
    { path: matches_explorer_path, name: 'Match explorer' }
  end

  def breadcrumb_class_name(breadcrumb_class)
    breadcrumb_class
      .name
      .underscore
      .humanize
      .pluralize
  end

  def breadcrumb_controller_name(breadcrumb_class)
    breadcrumb_class
      .to_s
      .underscore
      .downcase
      .pluralize
  end
end
