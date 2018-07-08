require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: @user) }
  let!(:comment) { create(:comment, commentable: question, user: @user) }

  describe "GET #create" do
    context 'with valid attrs' do
      it "create new comment" do
        expect { post :create,  params: { comment: attributes_for(:comment), question_id: question, format: :js } }.to change(question.comments, :count).by(1)
        expect(Comment.last.user_id).to eq @user.id
      end
    end

    context 'with invalid attrs' do
      it 'does not save comment' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :js }}.to_not change(Comment, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'Author try to delete comment' do
      it 'delete comment' do
        expect { delete :destroy, params: { id: comment, format: :js }}.to change(Comment, :count).by(-1)
      end
      it 'render destroy template' do
        delete :destroy, params: { id: comment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not author try to delete comment' do
      let!(:another_user) { create :user }
      let!(:not_authored_comment) { create(:comment, user: another_user, commentable: answer)}
      it 'does not delete comment' do
        expect{delete :destroy, params: {id: not_authored_comment, format: :js }}.to_not change(Comment, :count)
      end
    end
  end

  describe "PATCH #update" do
    before(:each) do
      patch :update, params: { id: comment, question_id: question, comment: {body: 'updated comment'}, format: :js }
    end
    it "update the comment" do
      comment.reload
      expect(comment.body).to eq 'updated comment'
    end

    it 'render update template' do
      expect(response).to render_template :update
    end
  end

end
