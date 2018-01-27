class CreateCampaignsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns_users do |t|
      t.integer :campaign_id, null: false
      t.integer :user_id,     null: false
    end

    add_index :campaigns_users, [:campaign_id, :user_id], unique: true
  end
end
