class NewBook < ActiveRecord::Base
  belong_to :user
  has_many :new_word_books, :dependent => :destroy
  has_many :words, through: :new_word_books
end