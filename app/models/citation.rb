class Citation < ActiveRecord::Base
  belongs_to :article
  belongs_to :cite, :class_name => "Article"
  attr_accessible :article_id, :cite_id
end
