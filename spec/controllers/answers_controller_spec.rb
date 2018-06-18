require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user}
  let!(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    let(:params) { { answer: attributes_for(:answer), question_id: question, format: :js }}

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
        expect { post :create, params: params_hash}.not_to change(Answer, :count)
      end

      it 're-render new view' do
        sign_in(user)
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js}
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
        expect { delete :destroy, params: { id: answer_with_author } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer_with_author }

        expect(response).to redirect_to answer_with_author.question
      end
    end

    context 'Non-Author tries to delete answer' do
      it 'not destroy answer' do
        expect { delete :destroy, params: { id: answer} }.to_not change(Answer, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to answer.question
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user
    let!(:answer) { create(:answer, question: question)}
    it 'assigns requested answer to @answer var' do
      patch :update,  params: { id: answer, question_id: question, user: user, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns question to @question var' do
      patch :update,  params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update,  params: { id: answer, question_id: question, answer: {body: "New body"}, format: :js }
      answer.reload

      expect(answer.body).to eq "New body"
    end

    it 'render update template' do
      patch :update,  params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

end
