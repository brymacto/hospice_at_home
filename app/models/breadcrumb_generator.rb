module BreadcrumbGenerator
  def load_breadcrumbs(breadcrumb_class, breadcrumb_object = nil, *actions)
    @breadcrumb_links = [class_breadcrumb(breadcrumb_class)]
    add_object_to_breadcrumb_links(breadcrumb_object)

    actions.each do |action|
      @breadcrumb_links << action_breadcrumb(breadcrumb_class, breadcrumb_object, action)
    end

    @breadcrumb_links
  end

  private

  def add_object_to_breadcrumb_links(breadcrumb_object)
    @breadcrumb_links << object_breadcrumb(breadcrumb_object) if breadcrumb_object
  end

  def class_breadcrumb(breadcrumb_class)
    { path: url_for(breadcrumb_class), name: breadcrumb_class_name(breadcrumb_class) }
  end

  def object_breadcrumb(breadcrumb_object)
    { path: url_for(breadcrumb_object), name: breadcrumb_object.name }
  end

  def action_breadcrumb(breadcrumb_class, breadcrumb_object, action)
    return match_explorer_breadcrumb if action == :match_explorer
    breadcrumb_object_id = (breadcrumb_object ? breadcrumb_object.id : nil)
    { path: url_for(controller: breadcrumb_controller_name(breadcrumb_class), action: action, id: breadcrumb_object_id), name: action.to_s.capitalize }
  end

  def match_explorer_breadcrumb
    { path: matches_explorer_path, name: 'Match explorer' }
  end

  def breadcrumb_class_name(breadcrumb_class)
    return 'Specialties' if breadcrumb_class == VolunteerSpecialty
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
