class CreateContentTexts < ActiveRecord::Migration[5.1]
  def change
    create_table :content_texts do |t|
      t.text    :content, null: false
      t.integer :ordering
      t.integer :visibility, null: false, default: 0, index: true

      t.timestamps
    end

    add_reference :content_texts, :hierarchy_element, index: true
  end
end
