class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :wordlist, :comment => '单词'
      t.string :translate, :comment => '翻译'
      t.string :pronunciation, :comment => '发音'
      t.string :example_sentence, :comment => '例句'
      t.string :other_wordlist, :comment => '其他写法'

      t.timestamps
    end
    add_index :activity_departments, :wordlist, unique: true
  end
end
