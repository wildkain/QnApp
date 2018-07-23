require 'rails_helper'

describe 'Answers API' do
  let(:user) { create :user }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 5, question: question, user: user) }
  let!(:answer) { answers.first }
  let!(:comment) { create(:comment, commentable: answer, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: answer) }


  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it_behaves_like "API successful response"

      it 'return answers collections' do
        expect(response.body).to have_json_size(5)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_request(question_id: question.id, access_token: access_token.token) }

      it_behaves_like "API successful response"

      %w(body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it_behaves_like "API Commentable"

      context 'attachments' do
        it 'attachment include answer object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        %w(url).each do |attr|
          it "answers attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end

  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:params) { { action: :create, format: :json, access_token: access_token.token, answer: attributes_for(:answer) } }
      before { do_request(params) }

      it_behaves_like "API successful response"

      it 'saves new answer database' do
        expect { do_request(params) }.to change(question.answers, :count).by(1)
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
