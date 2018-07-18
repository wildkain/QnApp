require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe  'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for Admin' do
    let(:user) { create(:user, admin: true)}
    it { should be_able_to :manage, :all}
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question }
    let(:authored_question) { create(:question, user: user) }
    let(:other_user_question) { create(:question, user: other_user) }
    let(:authored_answer) { create(:answer, user: user)}
    let(:other_user_answer) { create(:answer, user: other_user)}
    let(:authored_comment) { create(:comment, commentable: question, user: user)}
    let(:other_user_comment) { create(:comment, commentable: question, user: other_user)}
    let(:authored_question_attachment) { create(:attachment, attachmentable: authored_question)}
    let(:other_user_question_attachment) { create(:attachment, attachmentable: other_user_question)}
    let(:authored_answer_attachment) { create(:attachment, attachmentable: authored_answer)}
    let(:other_user_answer_attachment) { create(:attachment, attachmentable: other_user_answer)}

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, authored_question, user: user }
      it { should_not be_able_to :update, other_user_question, user: user }
      it { should be_able_to :destroy, authored_question, user: user }
      it { should_not be_able_to :destroy, other_user_question, user: user }
      it { should be_able_to :vote_count_up, other_user_question, user: user }
      it { should be_able_to :vote_count_down, other_user_question, user: user }
      it { should_not be_able_to :vote_count_up, authored_question, user: user }
      it { should_not be_able_to :vote_count_down, authored_question, user: user }
      it { should be_able_to :destroy, authored_question_attachment, user: user }
      it { should_not be_able_to :destroy, other_user_question_attachment, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other_user), user: user }
      it { should be_able_to :destroy, authored_answer, user: user }
      it { should_not be_able_to :destroy, other_user_answer, user: user }
      it { should be_able_to :vote_count_up, other_user_answer, user: user }
      it { should be_able_to :vote_count_down, other_user_answer, user: user }
      it { should_not be_able_to :vote_count_up, authored_answer, user: user }
      it { should_not be_able_to :vote_count_down, authored_answer, user: user }
      it { should be_able_to :best, create(:answer, user: other_user , question: authored_question) }
      it { should_not be_able_to :best, create(:answer, user: other_user , question: other_user_question) }
      it { should be_able_to :destroy, authored_answer_attachment, user: user }
      it { should_not be_able_to :destroy, other_user_answer_attachment, user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, create(:comment, commentable: question, user: user), user: user }
      it { should_not be_able_to :update, create(:comment, commentable: question, user: other_user), user: user }
      it { should be_able_to :destroy, authored_comment, user: user }
      it { should_not be_able_to :destroy, other_user_comment, user: user }
    end


  end
end