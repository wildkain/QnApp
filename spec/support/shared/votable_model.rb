# frozen_string_literal: true

shared_examples_for 'Votable Model' do
  describe '#vote' do
    it 'change votes counter' do
      expect { object.vote(user, 1) }.to change(Vote, :count).by 1
    end

    context  'vote must be correct' do
      before { @vote = object.vote(user, 1) }

      it 'change count' do
        expect(@vote.count).to eq 1
      end

      it 'have user reference' do
        expect(@vote.user_id).to eq user.id
      end

      it 'have reference to self' do
        expect(@vote.votable).to eq object
      end
    end
  end

  describe '#already_voted?' do
    let!(:vote) { create(:vote, :up, user: user, votable: object) }

    it 'return true if user already vote for resource' do
      expect(object.already_voted?(user, 1)).to eq true
    end

    it 'return false if resource have not user vote' do
      expect(object.already_voted?(another_user, 1)).to eq false
    end
  end

  describe '#votes_sum' do
    let!(:another_user) { create :user }

    it 'return sum of all votes for resource' do
      2.times do
        create(:vote, :up, user: user, votable: object)
      end
      3.times do
        create(:vote, :down, user: another_user, votable: object)
      end
      expect(object.votes_sum).to eq (0 + 2 - 3)
    end
  end
end
