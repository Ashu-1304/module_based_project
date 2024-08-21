
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe BxBlockAddressBlock::AddressesController, type: :controller do
  describe 'POST #fetch_location' do
    let(:valid_pincode) { '476115' }
    let(:invalid_pincode) { '999999' }
    let(:valid_country) { 'india' }
    let(:invalid_country) { 'mars' }
    let(:country_code) { 'in' }
    let(:controller) { BxBlockAddressBlock::AddressesController.new }
    

    before do
      stub_request(:get, "https://api.zippopotam.us/#{country_code}/#{valid_pincode}")
        .to_return(status: 200, body: '{"places":[{"place name":"porsa","state":"Some State","longitude":"12.34","latitude":"56.78"}]}', headers: {})

      stub_request(:get, "https://api.zippopotam.us/#{country_code}/#{invalid_pincode}")
        .to_return(status: 200, body: '{"places":[]}', headers: {})

      stub_request(:get, "https://api.zippopotam.us/#{invalid_country}/#{valid_pincode}")
        .to_return(status: 404, body: '{"error":"Not Found"}', headers: {})
    end

    context 'with valid parameters' do
      it 'returns the location data and creates a new Address record' do
        expect {
          get :fetch_location, params: { pincode: valid_pincode, country: valid_country }, as: :json
        }.to change(BxBlockAddressBlock::Address, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'Error in Address' do 
      before do 
        expect {
        get :fetch_location, params: { pincode: valid_pincode, country: valid_country }, as: :json
      }.to change(BxBlockAddressBlock::Address, :count).by(1)
      end
      it 'returns error' do
        expect {
          get :fetch_location, params: { pincode: valid_pincode, country: valid_country }, as: :json
        }.to change(BxBlockAddressBlock::Address, :count).by(0)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid pincode' do
      it 'returns an error message' do
        get :fetch_location, params: { pincode: invalid_pincode, country: valid_country }, as: :json

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with unsupported country' do
      it 'returns an error message' do
        get :fetch_location, params: { pincode: valid_pincode, country: invalid_country }, as: :json

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Unsupported country')
      end
    end

    context 'with missing parameters' do
      it 'returns an error message' do
        get :fetch_location, params: { pincode: valid_pincode }, as: :json

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to eq('Pincode and country are required')
      end
    end
  end


  describe 'GET #location_pincode' do
    let(:valid_pincode) { '412805' }
    let(:invalid_pincode) { '999999' }
    let(:stubbed_response) do
      {
        "place_id": "12345",
        "lat": "56.78",
        "lon": "12.34",
        "display_name": "Porsa, Some State, India"
      }.to_json
    end

    before do
      stub_request(:get, "https://nominatim.openstreetmap.org/search?accept-language=en&addressdetails=1&format=json&q=#{valid_pincode}")
        .to_return(status: 200, body: stubbed_response, headers: { 'Content-Type' => 'application/json' })

      stub_request(:get, "https://nominatim.openstreetmap.org/search?accept-language=en&addressdetails=1&format=json&q=#{invalid_pincode}")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end

    context 'when pincode is provided' do
      it 'returns the full location data' do
        get :location_pincode, params: { pincode: valid_pincode }, as: :json
        
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when no pincode is provided' do
      it 'returns an error message' do
        get :location_pincode, params: {}, as: :json
        
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Please provide Pincode?')
      end
    end

    context 'when no address is found' do
      it 'returns a not found error message' do
        get :location_pincode, params: { pincode: invalid_pincode }, as: :json
        
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('No Address Found?')
      end
    end
    
  end

end
