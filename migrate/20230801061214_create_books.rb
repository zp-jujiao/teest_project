class CreateBooks < ActiveRecord::Migration
  def change
    create_table :word_books do |t|
      t.string :name, :comment => '名称'
      t.string :desc, :comment => '描述'

      t.timestamps
    end
  end
end
