require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question)}

  describe "GET #index" do
    let(:questions) {create_list(:question, 2)}
    before {get :index}

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do

    before { get :show, params: { id: question } }

    it 'assigns requested question to @question var' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end

  end

  describe 'GET #edit' do
    sign_in_user

    before {get :edit, params: { id: question }}
    it 'assigns requested question to @question var' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new question in database' do
        expect { post :create,  params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create,  params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create,  params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create,  params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end

    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'with valid attributes' do

      it 'assigns requested question to @question var' do
        patch :update,  params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update,  params: { id: question, question: {title: "New title", body: "New body"} }
        question.reload
        expect(question.title).to eq "New title"
        expect(question.body).to eq "New body"
      end

      it 'redirect to updated question' do
        patch :update,  params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end

    end

    context 'with invalid attributes' do
      before { patch :update,  params: { id: question, question: {title: "New title", body: nil} } }
      it 'does not change attributes' do
        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 're-renders edit template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { question }
    it 'deletes question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end

  end

end
