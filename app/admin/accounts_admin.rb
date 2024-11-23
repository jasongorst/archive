Trestle.resource(:accounts) do
  menu do
    item :accounts, icon: "fa fa-star"
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :id
    column :email
    column :user
    column :bot_user
    column :admin, align: :center
    actions
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |account|
    text_field :email
    collection_select :user_id, User.all, :id, :display_name
    collection_select :bot_user_id, BotUser.all, :id, :display_name
    check_box :admin
    password_field :password
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:account).permit(:name, ...)
  # end
end
