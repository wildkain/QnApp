class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.integer   :count
      t.integer   :votable_id, index: true
      t.string    :votable_type, index: true
      t.timestamps
    end
  end
end
