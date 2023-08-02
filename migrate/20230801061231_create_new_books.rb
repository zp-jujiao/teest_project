class CreateNewBooks < ActiveRecord::Migration
  def change
    create_table :new_books do |t|
      t.string  :name,     :comment => '名称'
      t.string  :desc,     :comment => '描述'
      t.integer :user_id,  :comment => '用户表id'

      t.timestamps
    end
    add_index :new_books, :user_id
  end
end
