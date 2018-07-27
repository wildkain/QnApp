# frozen_string_literal: true
class Question < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  after_create :subscribe_author!

  validates :title, :body, presence: true

  private

  def subscribe_author!
    subscriptions.create(user: user)
  end
end
