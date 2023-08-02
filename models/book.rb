class Book < ActiveRecord::Base
  has_many :word_books, :dependent => :destroy
  has_many :words, through: :word_books
end