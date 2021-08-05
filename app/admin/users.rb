ActiveAdmin.register User do
  permit_params :slack_user, :display_name, :color

  index do
    selectable_column
    column :display_name
    column :slack_user
    column :color
    actions
  end

  config.sort_order = 'display_name_asc'

  filter :display_name_contains
  filter :slack_user_equals
  filter :color_equals

  show do
    attributes_table do
      row :display_name
      row :slack_user
      row :color
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs :display_name, :slack_user, :color
    f.actions
  end
end
