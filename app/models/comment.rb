class Comment < ActiveRecord::Base
  attr_accessible :author_id, :description

  belongs_to :commentable, :polymorphic => true
end
