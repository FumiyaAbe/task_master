module NavHelper
  # 例: nav_link_to "Tasks", tasks_path
  def nav_link_to(name, path, **opts)
    base = "inline-flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition hover:bg-gray-100"
    active = current_page?(path) ? " bg-gray-900 text-white hover:bg-gray-900" : " text-gray-700"
    classes = [ base, active, opts.delete(:class) ].compact.join(" ")
    link_to name, path, **opts.merge(class: classes)
  end
end
