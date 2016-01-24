module BreadcrumbGenerator
  def load_breadcrumbs(*breadcrumbs)
    @breadcrumb_links = breadcrumbs.map do |breadcrumb|
      {path: breadcrumb[0], name: breadcrumb[1]}
    end
  end

  def load_breadcrumbs_new(breadcrumb_class, breadcrumb_object = nil, *actions)
    @breadcrumb_links = [class_breadcrumb(breadcrumb_class)]
    add_object_to_breadcrumb(breadcrumb_object)

    actions.each do |action|
      @breadcrumb_links << action_breadcrumb(breadcrumb_object, action)
    end
  end

  private

  def add_object_to_breadcrumb(breadcrumb_object)
    @breadcrumb_links << object_breadcrumb(breadcrumb_object) if breadcrumb_object
  end

  def class_breadcrumb(breadcrumb_class)
    {path: url_for(breadcrumb_class), name: class_name(breadcrumb_class)}
  end

  def object_breadcrumb(breadcrumb_object)
    {path: url_for(breadcrumb_object), name: breadcrumb_object.name}
  end

  def action_breadcrumb(breadcrumb_object, action)
    return match_explorer_breadcrumb if action == :match_explorer
    {path: url_for({action: action}), name: action.capitalize}
  end

  def match_explorer_breadcrumb
    {path: matches_explorer_path, name: 'Match explorer'}
  end

  def class_name(breadcrumb_class)
    return 'Specialties' if breadcrumb_class == VolunteerSpecialty
    breadcrumb_class
      .name
      .underscore
      .humanize
      .pluralize
  end
end