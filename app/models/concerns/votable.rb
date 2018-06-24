module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, count)
    self.votes.create!( user:user, count:count )
  end


  def sum_all
    self.votes.sum(:count)
  end

end