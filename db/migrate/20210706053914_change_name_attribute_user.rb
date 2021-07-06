class ChangeNameAttributeUser < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :auth_thoken,  :auth_token
  end
end
