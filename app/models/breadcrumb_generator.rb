module BreadcrumbGenerator
  def load_breadcrumbs(crumb_class: nil, crumb_instance: nil, crumb_actions: [])
    validate_input(crumb_class, crumb_instance, crumb_actions)

    @breadcrumb_links = []

    load_class_breadcrumb(crumb_class)

    load_instance_breadcrumb(crumb_instance)

    load_action_breadcrumbs(crumb_class, crumb_instance, crumb_actions)

    @breadcrumb_links
  end

  private

  def validate_input(_crumb_class, _crumb_instance, crumb_actions)
    fail 'Crumb actions must be provided as an Array' if crumb_actions.class != Array
  end

  def load_class_breadcrumb(crumb_class)
    @breadcrumb_links.push(class_breadcrumb(crumb_class)) if crumb_class
  end

  def load_instance_breadcrumb(crumb_instance)
    @breadcrumb_links.push(instance_breadcrumb(crumb_instance)) if crumb_instance
  end

  def load_action_breadcrumbs(crumb_class, crumb_instance, crumb_actions)
    crumb_actions.each do |crumb_action|
      @breadcrumb_links.push(action_breadcrumb(crumb_class, crumb_instance, crumb_action))
    end
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
