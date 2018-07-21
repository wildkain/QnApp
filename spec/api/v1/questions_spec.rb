require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end

    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 5)}
      let(:question) { questions.first }
      let!(:answer) {create(:answer, question: question )}

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 OK' do
        expect(response).to be_successful
      end

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

  end

end