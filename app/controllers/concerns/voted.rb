module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_object, only: %i[ vote_count_up vote_count_down ]
  end


  def vote_count_up
    @votable_obj.vote(current_user, 1)
  end

  def vote_count_down
    @votable_obj.vote(current_user, -1)
  end


  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_object
    @votable_obj = model_klass.find(params[:id])
  end


end