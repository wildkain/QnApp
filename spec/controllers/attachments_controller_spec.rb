# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'GET #destroy' do
    sign_in_user

    let(:question) { create :question }
    let(:authored_question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, question: question, user: @user) }
    let(:non_author_answer) { create(:answer, question: question) }
    let!(:attachment) { create(:attachment, attachmentable: answer) }
    let!(:attachment_question) { create(:attachment, attachmentable: authored_question) }
    let!(:not_authored_attachment_question) { create(:attachment, attachmentable: question) }
    let!(:not_authored_attachment) { create(:attachment, attachmentable: non_author_answer) }

    context 'Answer author try to delete file' do
      it 'delete attachment from answer' do
        expect { delete :destroy, params: { id: attachment, format: :js  } }.to change(answer.attachments, :count).by(-1)
      end
    end

    context 'Not-author try to delete file' do
      it ' does not delete attachment from answer' do
        expect { delete :destroy, params: { id: not_authored_attachment, format: :js } }.to_not change(non_author_answer.attachments, :count)
      end
    end

    context 'Question author can delete attached file' do
      it 'delete attachment from question' do
        expect { delete :destroy, params: { id: attachment_question, format: :js  } }.to change(authored_question.attachments, :count).by(-1)
      end
    end

    context 'Not-author of question cant delete file' do
      it ' does not delete attachment from answer' do
        expect { delete :destroy, params: { id: not_authored_attachment_question, format: :js } }.to_not change(non_author_answer.attachments, :count)
      end
    end
  end
end
