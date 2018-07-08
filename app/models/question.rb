# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Attachable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true


end
