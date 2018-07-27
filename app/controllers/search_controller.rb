class SearchController < ApplicationController

  def index
    @results = Question.search(params[:query])
  end



end
