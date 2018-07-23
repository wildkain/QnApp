# frozen_string_literal: true

shared_examples_for 'API Commentable' do
  context 'comments' do
    %w[id body created_at updated_at].each do |attr|
      it "comment object in comments array contains #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path('comments/0')
      end
    end
  end
end
