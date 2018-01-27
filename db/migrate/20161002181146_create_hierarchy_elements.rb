class CreateHierarchyElements < ActiveRecord::Migration[5.1]
  def change
    create_table :hierarchy_elements do |t|
      t.string  :name,        null: false
      t.integer :visibility,  null: false, default: 0, index: true
      t.text    :description, null: true

      t.timestamps
    end

    add_reference :hierarchy_elements, :hierarchable, polymorphic: true,
                  index: { name: 'index_hierachy_elements_on_hierarchable' }
  end
end
