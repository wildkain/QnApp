module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_object, only: %i[ vote_count_up vote_count_down ]
  end


  def vote_count_up
    if @votable_obj.already_voted?(current_user, 1)
      render json: "You have already voted for this", status: 422
    else
      @votable_obj.vote(current_user, 1)
      render json: @votable_obj.votes.sum(:count)
    end
  end

  def vote_count_down
    if @votable_obj.already_voted?(current_user, -1)
      render json: "You have already voted for this", status: 422
    else
      @votable_obj.vote(current_user, -1)
      render json: @votable_obj.votes.sum(:count)
    end
  end



  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_object
    @votable_obj = model_klass.find(params[:id])
  end


end