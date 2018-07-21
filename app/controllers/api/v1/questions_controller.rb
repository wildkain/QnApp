class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: :show

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  def create
    respond_with(current_resource_owner.questions.create(question_params))
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
