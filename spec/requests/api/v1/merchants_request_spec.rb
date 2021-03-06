require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq 3
  end

  it "can show a merchant" do
    db_merchant = create(:merchant)

    get "/api/v1/merchants/#{db_merchant.id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body)
    expect(merchant["data"]["attributes"]["name"]).to eq db_merchant.name
  end

  it "can create a new merchant" do
    merchant_params = { name: "Saw"}

    post "/api/v1/merchants", params: {merchant: merchant_params}
    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Sledge" }

    put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Sledge")
  end

  it "can destroy an merchant" do
    merchant = create(:merchant)

    expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_success
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end