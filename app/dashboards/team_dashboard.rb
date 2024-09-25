require "administrate/base_dashboard"

class TeamDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    activated_user_access_token: Field::String,
    activated_user_id: Field::String,
    active: Field::Boolean,
    bot_user_id: Field::String,
    bot_users: Field::HasMany,
    domain: Field::String,
    name: Field::String,
    oauth_scope: Field::String,
    oauth_version: Field::String,
    team_id: Field::String,
    token: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    activated_user_access_token
    activated_user_id
    active
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    activated_user_access_token
    activated_user_id
    active
    bot_user_id
    bot_users
    domain
    name
    oauth_scope
    oauth_version
    team_id
    token
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    activated_user_access_token
    activated_user_id
    active
    bot_user_id
    bot_users
    domain
    name
    oauth_scope
    oauth_version
    team_id
    token
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how teams are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(team)
  #   "Team ##{team.id}"
  # end
end
