require 'rails_helper'

describe 'Profiles API' do

  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API successful response"


      %w[id email created_at updated_at admin].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end


  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'Authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:user) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API successful response"

      it 'does not contain current user and contains all users from collection ' do
        expect(response.body).to be_json_eql(users.to_json)
      end

    end
  end

  def do_request(options = {})
    get '/api/v1/profiles/', params: { format: :json }.merge(options)
  end
end