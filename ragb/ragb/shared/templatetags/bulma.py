from django import forms, template

register = template.Library()


@register.filter
def widget_type(field):
    return field.field.widget


@register.filter
def is_select(field):
    return isinstance(field.field.widget, forms.Select)


@register.filter
def is_multiple_select(field):
    return isinstance(field.field.widget, forms.SelectMultiple)


@register.filter
def is_textarea(field):
    return isinstance(field.field.widget, forms.Textarea)


@register.filter
def is_input(field):
    return isinstance(
        field.field.widget,
        (
            forms.TextInput,
            forms.NumberInput,
            forms.EmailInput,
            forms.PasswordInput,
            forms.URLInput,
        ),
    )


@register.filter
def is_checkbox(field):
    return isinstance(field.field.widget, forms.CheckboxInput)


@register.filter
def is_multiple_checkbox(field):
    return isinstance(field.field.widget, forms.CheckboxSelectMultiple)


@register.filter
def is_radio(field):
    return isinstance(field.field.widget, forms.RadioSelect)


@register.filter
def is_file(field):
    return isinstance(field.field.widget, forms.FileInput)


@register.filter
def bulmafy(field, css_class):
    if len(field.errors) > 0:
        css_class += " is-danger"
    field_classes = field.field.widget.attrs.get("class", "")
    field_classes += f" {css_class}"
    return field.as_widget(attrs={"class": field_classes})


@register.filter
def bulma_message_tag(tag):
    if tag == "error":
        return "danger"

    return tag
