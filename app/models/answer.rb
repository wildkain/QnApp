# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_ordered, -> { order(best: :desc) }

  def best?
    best == true
  end

  def best!
    question.answers.each do |answer|
      answer.update(best: false)
    end
    update(best: true)
  end

end
