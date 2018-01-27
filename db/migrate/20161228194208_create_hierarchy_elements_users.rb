class CreateHierarchyElementsUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :hierarchy_elements, :users, column_options: { null: false } do |t|
      t.index :hierarchy_element_id
      t.index :user_id
    end

    add_index :hierarchy_elements_users, [:hierarchy_element_id, :user_id], unique: true,
              name: 'hierarchy_elements_users_uniqueness'
  end
end
