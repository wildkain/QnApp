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
  let(:object) { create :question }
  it_behaves_like "Votable Model"
end
