class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment, only: %i[ destroy update ]
  before_action :load_commentable_obj, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def destroy
    @comment.destroy if current_user.author?(@comment)
  end

  def update
    @comment.update(comment_params) if current_user.author?(@comment)
  end

  private

  def publish_comment
    return if @comment.errors.any?
    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
    ActionCable.server.broadcast(
        "question-#{question_id}-comments",
        { comment: @comment.to_json } )
  end

  def load_commentable_obj
    @commentable = if params[:answer_id]
                     Answer.find(params[:answer_id])
                   elsif params[:question_id]
                     Question.find(params[:question_id])
                   end
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
