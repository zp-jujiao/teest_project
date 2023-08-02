class CreateWordBooks < ActiveRecord::Migration
  def change
    create_table :word_books do |t|
      t.integer :word_id, :comment => '单词表id'
      t.integer :book_id, :comment => '单词本表id'

      t.timestamps
    end
    add_index :word_books,:word_id
    add_index :word_books,:book_id
    add_index :word_books, [:word_id, :book_id], unique: true
  end
end
