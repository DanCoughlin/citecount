class Article < ActiveRecord::Base
  has_many :citations
  attr_accessible :author, :journal, :reference_type, :title, :year
end
