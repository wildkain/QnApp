# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[destroy update best]
  after_action :publish_answer, only: :create
  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author?(@answer)
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      respond_with(@answer)
    end
  end

  def best
    respond_with(@answer.best!) if current_user.author?(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def find_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    ActionCable.server.broadcast(
        "question-#{@question.id}",
        answer: @answer,
        counter: @answer.votes_sum,
        attachments: @answer.attachments)
  end
end
