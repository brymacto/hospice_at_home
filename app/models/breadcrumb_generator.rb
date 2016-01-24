module BreadcrumbGenerator
  def load_breadcrumbs(*breadcrumbs)
    @breadcrumb_links = breadcrumbs.map do |breadcrumb|
      { path: breadcrumb[0], name: breadcrumb[1]}
    end
  end
end