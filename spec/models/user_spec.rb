require 'rails_helper'


RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:comments) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:not_author_user) { create :user}
  let(:answer) { create(:answer, question: question, user: user) }


  context 'Check #author? for question' do
    it 'author of question must be author ' do
      expect(user).to be_author(question)
    end

    it 'non-author must not be author of question' do
      expect(not_author_user).to_not be_author(question)
    end

  end

  context 'Check author of answer' do
    it 'author of answer must be author ' do
      expect(user).to be_author(answer)
    end

    it 'non-author must not be author of answer' do
      expect(not_author_user).to_not be_author(answer)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user)}
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456')}

    context 'user already have authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: {email: user.email})}
        it 'does not create a new user' do
          expect { User.find_for_oauth(auth)}.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization =  User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user object' do
          expect(User.find_for_oauth(auth)).to eq user
        end

      end
      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: {email: 'example@mail.com'})}

        it 'creates new user' do
          expect{User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end
        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

    end
  end

  describe '.send_daily_digest' do
    let!(:user) { create(:user)}

    it 'should send daily digest to all users' do
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
      User.send_daily_digest
    end

  end

  describe '#subscribed?' do
    let(:user) { create :user }
    let(:not_subscribed_user) { create :user}
    let(:question) { create :question }
    let!(:subscription) { create(:subscription, user: user, question: question)}

    it 'should be return true if user subscribed for question' do
      expect(user.subscribed?(question)).to eq true
    end

    it 'should return false if user has not subs' do
      expect(not_subscribed_user.subscribed?(question)).to eq false
    end

  end
end
