class AdminUser < ApplicationRecord
  include Clearance::User

  validates :password, password_strength: true
end
