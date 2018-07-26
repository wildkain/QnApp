# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  scope :best_ordered, -> { order(best: :desc) }

  after_create :notify

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end



  def notify
    NotifySubscribersJob.perform_later(self)
  end

end
