class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except:  %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  #after_action :publish_question, only: :create

  def index
    @questions = Question.all.order(created_at: :desc)
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build

  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      publish_question
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    @question.destroy if current_user.author?(@question)

    redirect_to questions_path
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question',
          locals: { current_user: current_user, question: @question }
        )
    )
  end

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
