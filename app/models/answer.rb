# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Attachable

  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  scope :best_ordered, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
