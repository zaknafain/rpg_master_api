class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string  :name,            null: false
      t.string  :email,           null: false
      t.string  :password_digest, null: false
      t.string  :remember_token
      t.string  :locale,          null: false, default: I18n.default_locale
      t.boolean :admin,           null: false, default: false

      t.timestamps
    end

    add_index :users, :email,          unique: true
    add_index :users, :remember_token, unique: true
  end
end
