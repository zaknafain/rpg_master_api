class CreateContentTextsUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :content_texts, :users, column_options: { null: false } do |t|
      t.index :content_text_id
      t.index :user_id
    end

    add_index :content_texts_users, %i[content_text_id user_id], unique: true,
                                                                 name: 'content_texts_users_uniqueness'
  end
end
