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

    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

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
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get "/api/v1/answers/#{answer.id}", params: { question_id: question.id, format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { question_id: question.id, format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: { question_id: question.id, format: :json, access_token: access_token.token }}
      it_behaves_like "API successful response"

      %w(body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do

        %w(id body created_at updated_at).each  do |attr|
          it "comment object in comments array contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0")
          end
        end
      end

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

  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:params) { { action: :create, format: :json, access_token: access_token.token, answer: attributes_for(:answer) } }
      before { post "/api/v1/questions/#{question.id}/answers", params: params }

      it_behaves_like "API successful response"

      it 'saves new answer database' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: params }.to change(question.answers, :count).by(1)
      end
    end
  end


  end