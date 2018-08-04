class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except:  %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create
  before_action :build_answer, only: :show
  before_action :load_subscription, only: %i[show update]

  respond_to :html
  respond_to :js, only: :update
  authorize_resource

  def index
    @questions = Question.paginate(page: params[:page], per_page: 10).order('created_at DESC')
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = current_user.questions.build)
  end

  def edit; end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update

    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy) if current_user.author?(@question)
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    logger.debug "Question attributes hash: #{@question.attributes.inspect}"
    return if @question.errors.any? || @question.nil?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question_for_cable',
          locals: { question: @question }
        )
    )
  end

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
  end

  def load_subscription
    @subscription = current_user.subscriptions.where(question: @question).first if current_user
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
