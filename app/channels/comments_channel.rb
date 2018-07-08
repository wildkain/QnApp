class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question-#{params['question_id']}-comments"
  end
end
