require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves the answer in database' do
        params_hash = { answer: attributes_for(:answer), question_id: question }
        expect { post :create, params: params_hash }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end

    end

    context 'with invalid attributes' do

      it 'does not save the answer in database' do
        params_hash = { answer: attributes_for(:invalid_answer), question_id: question}
        expect { post :create, params: params_hash}.not_to change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question}
        expect(response).to render_template :new
      end

    end
  end


  describe 'GET #show' do
    let(:answer) { question.answers.create(body: "MyText") }
    before {get :show, params: { id: answer }}

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns requested answer to @question var' do
      expect(assigns(:answer)).to eq answer
      end
  end


end
