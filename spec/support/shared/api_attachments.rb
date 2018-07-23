shared_examples_for "API Attachable" do

  context 'attachments' do
    it 'resource have attachment object' do
      expect(response.body).to have_json_size(1).at_path("attachments")
    end

    %w(url).each do |attr|
      it "resource attachment object contains #{attr}" do
        expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
      end
    end
  end
end