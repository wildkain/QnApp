class SearchController < ApplicationController

  def index
    if params[:query].nil?
      redirect_to root_path, notice: "Bad request"
    else
      resource = params[:resource].constantize unless params[:resource].empty?
      @results = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query]), classes: [resource]
    end
  end

end
