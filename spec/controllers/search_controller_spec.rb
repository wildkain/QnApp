require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'search for question' do
      get :index, params: { query: 'search query' }
      expect(response).to render_template :index
    end
  end

end
