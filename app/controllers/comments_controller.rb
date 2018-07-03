class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment, only: %i[ destroy update ]
  before_action :load_question, only: :create

  def create
    @comment = @question.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
  end

  def destroy
    @comment.destroy if current_user.author?(@comment)
  end

  def update
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
