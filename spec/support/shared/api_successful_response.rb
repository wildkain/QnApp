shared_examples_for "API successful response" do
  it 'returns status 200 OK' do
    expect(response).to be_successful
  end
end