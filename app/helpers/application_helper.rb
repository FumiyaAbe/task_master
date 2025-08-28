module ApplicationHelper
  # 使い方:
  #   nav_link_to "Tasks", tasks_path, variant: :dark, match: :prefix
  #   nav_link_to "Tasks", tasks_path, variant: :dark, starts_with: [tasks_path, "/task_board"]
  def nav_link_to(name, path, match: :exact, starts_with: nil, **opts)
    given_class = opts.delete(:class)
    variant     = opts.delete(:variant)&.to_sym

    active =
      if starts_with.present?
        Array(starts_with).any? { |prefix| request.path == prefix || request.path.start_with?("#{prefix}/") }
      elsif match == :prefix
        request.path == path || request.path.start_with?("#{path}/")
      else
        current_page?(path)
      end

    base = "inline-flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition"

    if variant == :dark
      idle       = "!text-white hover:bg-white/10"
      active_cls = "bg-white/10 !text-white"
    else
      idle       = "text-gray-700 hover:bg-gray-100"
      active_cls = "bg-gray-100 text-gray-900"
    end

    classes = [ base, (active ? active_cls : idle), given_class ].compact.join(" ")
    link_to name, path, opts.merge(class: classes)
  end
end
