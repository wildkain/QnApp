module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, count)
    transaction do
      self.votes.where(user: user).destroy_all
      self.votes.create!( user: user, count: count )
    end

  end

  def already_voted?(user, count)
    self.votes.where(user: user, count: count).exists?
  end


  def sum_all
    self.votes.sum(:count)
  end

end
