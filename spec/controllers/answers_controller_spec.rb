# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    let(:params) { { answer: attributes_for(:answer), question_id: question, format: :js } }

    context 'with valid attributes' do
      it 'saves new answer in database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'the answer belongs to user' do
        expect { post :create, params: params }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context 'Signed_in user save answer with invalid attributes' do
      it 'does not save the answer in database' do
        sign_in(user)
        params_hash = { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect { post :create, params: params_hash }.not_to change(Answer, :count)
      end

      it 're-render new view' do
        sign_in(user)
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:answer) { create(:answer, question: question) }
    let!(:answer_with_author) { create(:answer, question: question, user: @user) }

    context 'Author try to delete answer' do
      it 'destroy answer' do
        expect { delete :destroy, params: { id: answer_with_author, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer_with_author, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'Non-Author tries to delete answer' do
      it 'not destroy answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:answer) { create(:answer, question: question) }
    let!(:authored_answer) { create(:answer, question: question, user: @user) }

    context 'Author try to update answer' do
      it 'assigns requested answer to @answer var' do
        patch :update,  params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

        expect(assigns(:answer)).to eq answer
      end

      it 'assigns question to @question var' do
        patch :update, params: { id: answer, question_id: question,
                                 answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: { id: authored_answer, question_id: question, answer: { body: 'New body' }, format: :js }
        authored_answer.reload

        expect(authored_answer.body).to eq 'New body'
      end

      it 'render update template' do
        patch :update,  params: { id: authored_answer, question_id: question,
                                  answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'Not-Author try to update answer' do
      it 'Not change answer attrs' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'New body' }, format: :js }

        expect(answer.body).to_not eq 'New body'
      end
    end
  end

  describe 'PATCH #best' do
    sign_in_user
    let(:authored_question) { create(:question, user: @user) }
    let!(:not_authored_question_answer) { create(:answer, question: question) }
    let!(:answer) { create(:answer, question: authored_question) }

    context 'Author set best answer' do
      it 'assign best attr to answer' do
        patch :best,  params: { id: answer, format: :js }

        expect(assigns(:answer)).to be_best
      end

      it 'renders best template' do
        patch :best, params: { id: answer, format: :js }

        expect(response).to render_template :best
      end
    end

    context 'Not-Author try to set best answer' do
      it 'does not set best answer' do
        patch :best, params: { id: not_authored_question_answer, format: :js }

        expect(not_authored_question_answer.best).to eq false
      end
    end
  end

  describe 'POST #vote_count_up(or down)' do
    sign_in_user
    let(:authored_question) { create(:question, user: @user) }
    let!(:object) { create(:answer, question: authored_question) }
    let!(:authored_object) { create(:answer, user: @user, question: authored_question) }
    it_behaves_like 'Votable Controller'
  end
end
