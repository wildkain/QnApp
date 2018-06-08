require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user}
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    let(:params) { { answer: attributes_for(:answer), question_id: question }}

    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'the answer belongs to user' do
        expect { post :create, params: params }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'Signed_in user save answer with invalid attributes' do
      it 'does not save the answer in database' do
        sign_in(user)
        params_hash = { answer: attributes_for(:invalid_answer), question_id: question}
        expect { post :create, params: params_hash}.not_to change(Answer, :count)
      end

      it 're-render new view' do
        sign_in(user)
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question}
        expect(response).to render_template 'questions/show'
      end
    end
  end


  describe 'GET #show' do
    let(:answer) { question.answers.create(body: "MyText", user: user) }
    before {sign_in(user)}
    before {get :show, params: { id: answer }}

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns requested answer to @question var' do
      expect(assigns(:answer)).to eq answer
      end
  end
end
