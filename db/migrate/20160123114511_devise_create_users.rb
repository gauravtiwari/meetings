class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :name,              null: false, default: ""
      t.string :username,              null: false, default: ""
      t.string :first_name,              null: false, default: ""
      t.string :last_name,              null: false, default: ""
      t.string :avatar, default: ""
      t.string :phone
      t.string :pin
      t.boolean :phone_verified, null: false, default: false
      t.jsonb :meta, null: false, default: '{}'
      t.jsonb :preferences, null: false, default: '{}'
      t.string :encrypted_password, null: false, default: ""
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end
end
