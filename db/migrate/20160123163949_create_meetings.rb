class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'citext'
    create_table :meetings do |t|
      t.references :user, index: true, foreign_key: true
      t.string :meeting_id
      t.timestamp :starts_at
      t.timestamp :ends_at
      t.jsonb :info, null: false, default: '{}'
      t.timestamps
    end
    add_index :meetings, :info, using: :gin
    add_index :meetings, :meeting_id, unique: true
  end
end
