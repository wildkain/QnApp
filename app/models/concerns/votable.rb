module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    transaction do
      self.votes.where(user: user).destroy_all
      self.votes.create!( user: user, count: value )
    end

  end

  def already_voted?(user, value)
    self.votes.where(user: user, count: value).exists?
  end

  def votes_sum
    self.votes.sum(:count)
  end

end
