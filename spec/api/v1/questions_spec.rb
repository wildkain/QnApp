require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 5)}
      let(:question) { questions.first }
      let!(:answer) {create(:answer, question: question )}

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "API successful response"

      it 'return questions collections' do
        expect(response.body).to have_json_size(5)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10)).at_path("0/short_title")
      end

      context 'answers' do

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: {format: :json}.merge(options)
    end
  end


  describe 'GET /show' do
    let(:question) { create :question }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end

    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) {create(:answer, question: question )}
      let!(:comments) {create_list(:comment, 5, commentable: question, user: user)}
      let!(:comment) { comments.first }
      let!(:attachment) { create(:attachment, attachmentable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like "API successful response"

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
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
        it 'attachment include question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        %w(url).each do |attr|
          it "question's attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end


  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/", params: { action: :create, format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/", params: { action: :create, format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) { { format: :json, access_token: access_token.token, question: attributes_for(:question) } }

      before { post '/api/v1/questions', params: params }

      it_behaves_like "API successful response"

      it 'creates new qustions and saves to db' do
        expect{ post '/api/v1/questions/', params: params }.to change { Question.count }.by(1)
      end
    end

  end

end