SimpleForm.setup do |config|
  INPUT_CLASS = "input"
  LABEL_CLASS = "form-label"
  HINT_CLASS  = "form-hint"
  ERROR_CLASS = "form-error"

  config.wrappers :tailwind, class: "mb-4", error_class: "has-error" do |b|
    b.use :html5
    b.use :placeholder

    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: LABEL_CLASS
    b.use :input, class: INPUT_CLASS
    b.use :hint,  wrap_with: { tag: :p, class: HINT_CLASS }
    b.use :error, wrap_with: { tag: :p, class: ERROR_CLASS }
  end

  config.default_wrapper = :tailwind
  config.button_class = "btn"
  config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}".strip }
end
