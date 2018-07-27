require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  sign_in_user
  describe "POST #create" do

    it "create a new subscription" do
      expect { post :create, params: {question_id: question.id, format: :js  } }.to change(@user.subscriptions, :count).by(1)
    end

    it 'render template' do
      post :create, params: {question_id: question.id, format: :js }
      expect(response).to render_template :create
    end
  end

  describe "GET #destroy" do
    let!(:subscription){ create(:subscription, user: @user, question: question)}
    it "destroy user subscription" do
      expect { delete :destroy, params: {id: subscription, format: :js  } }.to change(@user.subscriptions, :count).by(-1)
    end

    it 'render template' do
      delete :destroy, params: {id: subscription, format: :js  }
      expect(response).to render_template :destroy
    end
  end

end
