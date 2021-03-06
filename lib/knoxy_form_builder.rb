require 'action_view/helpers/form_helper'

class KnoxyFormBuilder < SimpleForm::FormBuilder
  def inner_field(field, options = {})
    full_field = @template.content_tag(:div, class: 'field-holder') do
      input_field = String.new
      input_field << @template.content_tag(:div, class: "left-label") do
        label_text = options.delete(:label)
        if label_text.present?
          self.label(field, label_text)
        else
          self.label(field)
        end
      end.html_safe

      input_field << @template.content_tag(:div, class: "field") do
        yield
      end.html_safe
      input_field.html_safe
    end
    full_field.html_safe
  end

  def inner_field_group(field, options = {})
    full_field = @template.content_tag(:div, class: 'field-holder') do
      input_field = ''
      input_field << @template.content_tag(:div, class: "left-labels") do
        label_text = options.delete(:label)
        if label_text.present?
          self.label(field, label_text)
        else
          self.label(field)
        end
      end.html_safe

      input_field << @template.content_tag(:div, class: "well") do
        @template.content_tag(:div) do
          yield
        end.html_safe
      end.html_safe
      input_field.html_safe
    end
    full_field.html_safe
  end

  def full_field_group(field, options = {})
    full_field = @template.content_tag(:div, class: 'field-holder') do
      input_field = String.new
      input_field << @template.content_tag(:div, class: "field full-group-field") do
        @template.content_tag(:div, class: "full-group") do
          yield
        end.html_safe
      end.html_safe
      input_field.html_safe
    end
    full_field.html_safe
  end

  def group_item(field, options = {})
    full_field = @template.content_tag(:div) do
      input_field = String.new
      input_field << @template.content_tag(:div) do
        label_text = options.delete(:label)
        if label_text.present?
          self.label(field, label_text)
        else
          self.label(field)
        end
      end.html_safe

      input_field << @template.content_tag(:div) do
        yield
      end.html_safe
      input_field.html_safe
    end
    full_field.html_safe
  end
end

