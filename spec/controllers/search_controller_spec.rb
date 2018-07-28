require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do

    it "returns http success" do
      get :index, params: {resource: "Question", query: "test" }
      expect(response).to have_http_status(:success)
    end

    %w(Questions Answers Comments Users).each do |resource|
      it "search for resource: #{resource}"  do
        expect(ThinkingSphinx.search).to receive(ThinkingSphinx::Query.escape(:query)).with('Query', resource)
        get :index, params: { query: 'Query', resource: resource }
      end
      it 'renders index template' do
        get :index, params: { query: 'Query', resource: resource }
        expect(response).to render_template :index
      end
    end
  end

end
