class CreateNewWordBooks < ActiveRecord::Migration
  def change
    create_table :new_word_books do |t|
      t.integer :word_id,  :comment => '单词表id'
      t.integer :new_book_id,  :comment => '单词表id'
      t.boolean :is_master, default: false, :comment => '是否掌握'

      t.timestamps
    end
    add_index :new_word_books, :word_id
    add_index :new_word_books, :new_book_id
    add_index :new_word_books, [:word_id, :new_book_id], unique: true
    add_index :new_word_books, :is_master
  end
end
