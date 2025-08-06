Trestle.resource(:bot_users) do
  menu do
    item :bot_users, icon: "fa fa-star"
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :id
    column :display_name
    column :slack_user
    column :team
    actions
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |bot_user|
    text_field :slack_user
    text_field :display_name
    collection_select :team_id, Team.all, :id, :name
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:bot_user).permit(:name, ...)
  # end
end
