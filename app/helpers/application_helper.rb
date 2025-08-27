module ApplicationHelper
  # 使い方:
  #   nav_link_to "Tasks", tasks_path                 # 通常(ライト)ナビ
  #   nav_link_to "Tasks", tasks_path, variant: :dark # 濃色ナビ上(白文字)
  def nav_link_to(name, path, **opts)
    given_class = opts.delete(:class)
    variant     = opts.delete(:variant)&.to_sym
    active      = current_page?(path)

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
