# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable,  dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  validates :body, presence: true

  scope :best_ordered, -> { order(best: :desc) }

  def best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
