require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user}
  describe 'POST #create' do
    context 'Signed_in user try to save answer with valid attributes' do

      it 'saves the answer in database' do
        sign_in(user)
        params_hash = { answer: attributes_for(:answer), question_id: question }
        expect { post :create, params: params_hash }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        sign_in(user)
        post :create, params: { answer: attributes_for(:answer), question_id: question }
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
    let(:answer) { question.answers.create(body: "MyText") }
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
