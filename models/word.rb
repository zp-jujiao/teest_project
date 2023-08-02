class Word < ActiveRecord::Base
  has_many :word_books, :dependent => :destroy
  has_many :books, through: :word_books
  has_many :new_word_books, :dependent => :destroy
  has_many :new_books, through: :new_word_books
end