class CreateIdentities < ActiveRecord::Migration[5.0]
  def self.up
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider, index: true
      t.string :uid, index: true
      t.string :secret, index: true
      t.string :token, index: true
      t.timestamps null: false
    end
    add_index :identities, [:uid, :provider, :user_id], unique: true
  end

  def self.down
    drop_table(:identities)
  end
end
