# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question var' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
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
    let!(:authored_question) { create(:question, user: @user) }

    before { get :edit, params: { id: authored_question } }
    it 'assigns requested question to @question var' do
      expect(assigns(:question)).to eq authored_question
    end

    it 'renders edit view' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        expect(Question.last.user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create,  params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:authored_question) { create(:question, user: @user) }
    context 'Author with valid attributes' do
      it 'assigns requested question to @question var' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: authored_question, question: { title: 'New title', body: 'New body', user: @user }, format: :js }
        authored_question.reload
        expect(authored_question.title).to eq 'New title'
        expect(authored_question.body).to eq 'New body'
      end

      it 'redirect to updated question' do
        patch :update, params: { id: authored_question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to authored_question
      end
    end

    context 'Not-athored user with valid attrs' do
      it 'does not change attrs' do
        patch :update, params: { id: question,
                                 question: { title: 'New title', body: 'New body' },
                                 format: :js }
        expect(question.title).to_not eq 'New title'
        expect(question.body).to_not eq 'New body'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'New title', body: nil }, format: :js } }
      it 'does not change attributes' do
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:authored_question) { create(:question, user: @user) }
    before { question }

    context  'User tries to delete authored question' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: authored_question } }.to change(Question, :count).by(-1)
      end
    end

    context 'User tries to delete not-authored question' do
      it 'no changes in questions count' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end

  describe 'POST #vote_count_up(or down)' do
    sign_in_user
    let(:another_user) { create :user }
    let(:object) { create(:question, user: another_user) }
    let(:authored_object) { create(:question, user: @user) }
    it_behaves_like 'Votable Controller'
  end
end
