class RemoveInheritColorsFromUsers < ActiveRecord::Migration[7.1]
  def up
    change_column_null :users, :color, true
    change_column_default :users, :color, nil

    User.where(color: "inherit").update(color: nil)
  end

  def down
    change_column_null :users, :color, false
    change_column_default :users, :color, "inherit"

    User.where(color: nil).update(color: "inherit")
  end
end
