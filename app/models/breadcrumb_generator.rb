module BreadcrumbGenerator
  def load_breadcrumbs(crumb_class: nil, crumb_instance: nil, crumb_actions: [])
    @crumb_class = crumb_class
    @crumb_instance = crumb_instance
    @crumb_actions = crumb_actions
    @breadcrumb_links = []

    validate_input

    load_class_breadcrumb

    load_instance_breadcrumb

    load_action_breadcrumbs

    @breadcrumb_links
  end

  private

  def validate_input
    fail 'Crumb actions must be provided as an Array' if @crumb_actions && @crumb_actions.class != Array
  end

  def load_class_breadcrumb
    @breadcrumb_links.push(class_breadcrumb) if @crumb_class
  end

  def load_instance_breadcrumb
    @breadcrumb_links.push(instance_breadcrumb) if @crumb_instance
  end

  def load_action_breadcrumbs
    @crumb_actions.each do |crumb_action|
      @breadcrumb_links.push(action_breadcrumb(crumb_action))
    end
  end

  def class_breadcrumb
    { path: url_for(@crumb_class), name: breadcrumb_class_name(@crumb_class) }
  end

  def instance_breadcrumb
    { path: url_for(@crumb_instance), name: @crumb_instance.name }
  end

  def action_breadcrumb(action)
    return match_explorer_breadcrumb if action == :match_explorer
    breadcrumb_instance_id = (@crumb_instance ? @crumb_instance.id : nil)
    { path: url_for(controller: breadcrumb_controller_name(@crumb_class), action: action, id: breadcrumb_instance_id), name: action.to_s.capitalize }
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
