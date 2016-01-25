class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.references :meeting, index: true, foreign_key: true

      t.timestamps
    end
    add_index :events, [:user_id, :meeting_id], unique: true
  end
end
