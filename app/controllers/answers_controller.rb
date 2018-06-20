# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[destroy update best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @answer.best! if current_user.author?(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
