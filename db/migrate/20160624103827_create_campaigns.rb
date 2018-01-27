class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string  :name,             null: false
      t.integer :user_id,          null: false
      t.text    :short_description
      t.text    :description,      null: false
      t.boolean :is_public,        null: false, default: false

      t.timestamps
    end

    add_index :campaigns, :user_id
  end
end
