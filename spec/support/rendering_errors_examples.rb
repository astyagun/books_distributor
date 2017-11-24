RSpec.shared_examples_for 'rendering 404 error' do
  it 'renders 404 error', :aggregate_failures do
    expect(parsed_response).to eq(
      'status' => 404,
      'detail' => 'Record not found'
    )
    expect(response).to have_http_status :not_found
  end
end
