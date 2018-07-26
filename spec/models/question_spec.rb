require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question)}
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy)}
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  let(:user) {create :user}
  let(:another_user) { create :user }
  let(:question) { create(:question, user: user)}
  let(:object) { create :question }

  it_behaves_like "Votable Model"

  describe "#subscribe_author!" do
    it 'subscribe author to new question after create' do
      expect(question.subscriptions.count).to eq 1
      expect(question.subscriptions.first.user_id).to eq question.user_id
    end
  end
end
