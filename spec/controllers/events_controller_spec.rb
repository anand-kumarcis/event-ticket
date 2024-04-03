require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  before do
    sign_in user
  end
  describe "GET #index" do
    context "when cache exists" do
      it "retrieves events from cache" do
        allow(Rails.cache).to receive(:fetch).with('all_events', expires_in: 5.minutes).and_return([Event.new(name: "Event 1")])

        get :index

        expect(assigns(:events)).to eq([Event.new(name: "Event 1")])
      end
    end

    context "when cache doesn't exist" do
      it "fetches events from database" do
        allow(Rails.cache).to receive(:fetch).and_return(nil)
        allow(Event).to receive(:all).and_return([Event.new(name: "Event 1")])

        get :index

        expect(assigns(:events)).to eq([Event.new(name: "Event 1")])
      end
    end
  end
end