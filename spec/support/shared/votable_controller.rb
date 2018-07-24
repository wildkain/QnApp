# frozen_string_literal: true

shared_examples_for 'Votable Controller' do
  context 'Registered user try to vote UP' do
    it 'should change votes count' do
      post :vote_count_up, params: { id: object, user: @user, count: 1, format: :js }
      expect(object.votes_sum).to eq 1
    end
  end

  context 'Registered user try to vote DOWN' do
    it 'should change votes count' do
      post :vote_count_down, params: { id: object, user: @user, count: -1, format: :js }

      expect(object.votes_sum).to eq -1
    end
  end

  context 'Registered user try vote twice(or more)' do
    it 'should get 422 error' do
      create(:vote, :up, user: @user, votable: object)
      post :vote_count_up, params: { id: object, user: @user, count: 1, format: :js }

      expect(response).to have_http_status 422
    end
  end

  context 'Author try to vote own object' do
    it 'should get forbidden error' do
      post :vote_count_up, params: { id: authored_object, user: @user, count: 1, format: :js }

      expect(response).to have_http_status 403
      expect(object.votes_sum).to eq 0
    end
  end

  context 'Not-logged_in user try to vote' do
    it 'should get forbidden error' do
      sign_out @user
      post :vote_count_up, params: { id: authored_object, user: nil, count: 1, format: :js }
      expect(response).to have_http_status 401
      expect(authored_object.votes_sum).to eq 0
    end
  end
end
