require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: "Updated Event Name" } }
  let(:invalid_attributes) { { name: "" } }
  let(:event) { create(:event) }
  let(:event1) { create(:event, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when cache exists" do
      it "retrieves events from cache" do
        allow(Rails.cache).to receive(:fetch).with('all_events', expires_in: 5.minutes).and_return([Event.new(name: "Event 1")])

        get :index

        expect(assigns(:events)).not_to be_nil
        expect(assigns(:events).map(&:attributes)).to eq([Event.new(name: "Event 1").attributes])
      end
    end

    describe "GET #new" do
      it "assigns a new event to @event" do
        get :new
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "renders the new template" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        it "updates the requested event" do
          put :update, params: { id: event.to_param, event: valid_attributes }
          event.reload
          expect(event.name).to eq("Updated Event Name")
        end

        it "redirects to the event" do
          put :update, params: { id: event.to_param, event: valid_attributes }
          expect(response).to redirect_to(event)
        end

        it "sets flash notice message" do
          put :update, params: { id: event.to_param, event: valid_attributes }
          expect(flash[:notice]).to eq("Event updated successfully")
        end
      end

      context "with invalid params" do
        it "does not update the event" do
          put :update, params: { id: event.to_param, event: invalid_attributes }
          event.reload
          expect(event.name).not_to eq("") # Make sure the event name didn't change
        end

        it "re-renders the 'edit' template" do
          put :update, params: { id: event.to_param, event: invalid_attributes }
          expect(response).to render_template("edit")
        end

        it "sets flash alert message" do
          put :update, params: { id: event.to_param, event: invalid_attributes }
          expect(flash[:alert]).to eq("Failed to update event")
        end
      end
    end
  end

  describe "DELETE #destroy" do 
    it "sets a flash notice message" do
      delete :destroy, params: { id: event1.id }
      expect(flash[:notice]).to eq("Event deleted successfully")
    end

    it "redirects to events index page" do
      delete :destroy, params: { id: event1.id }
      expect(response).to redirect_to(events_path)
    end
  end

  describe "POST #create" do
    let(:valid_event_params) { attributes_for(:event, user_id: user.id) }
    let(:invalid_event_params) { attributes_for(:event, name: nil) }

    context "with valid parameters" do
      it "creates a new event" do
        expect {
          post :create, params: { event: valid_event_params }
        }.to change(Event, :count).by(1)
      end

      it "redirects to my_events page" do
        post :create, params: { event: valid_event_params }
        expect(response).to redirect_to(my_events_events_path(user_id: user.id))
      end

      it "sets flash notice message" do
        post :create, params: { event: valid_event_params }
        expect(flash[:notice]).to eq("Event created successfully")
      end
    end

    context "with invalid parameters" do
      it "does not create a new event" do
        expect {
          post :create, params: { event: invalid_event_params }
        }.not_to change(Event, :count)
      end

      it "renders new template" do
        post :create, params: { event: invalid_event_params }
        expect(response).to render_template(:new)
      end

      it "sets flash alert message" do
        post :create, params: { event: invalid_event_params }
        expect(flash.now[:alert]).to eq("Failed to create event")
      end
    end
  end

  describe 'POST #book_ticket' do
    let(:event) { create(:event) }
    let(:ticket_params) { { quantity: 1 } } # Adjust as needed based on your ticket_params
    before do 
      post :book_ticket, params: { id: event.id, ticket: ticket_params }
    end  
    context 'when tickets are available' do
      it 'creates a new ticket and updates event booked_tickets' do
        expect(flash[:notice]).to eq('Tickets booked successfully')
      end
    end

    context 'when tickets are not available' do
      before do
        # Assuming all tickets are booked to make tickets unavailable
        event.update(booked_tickets: event.total_tickets)
      end

      it 'does not create a new ticket' do
        expect {
          post :book_ticket, params: { id: event.id, ticket: ticket_params }
        }.not_to change(Ticket, :count)
      end
    end
  end

  describe '#tickets_are_available?' do
    let(:event) { create(:event, total_tickets: 10, booked_tickets: 5) }
    let(:ticket) { instance_double('Ticket', quantity: 2) } # Adjust as needed based on your Ticket model

    it 'returns true if tickets are available' do
      expect(controller.tickets_are_available?(ticket, event)).to be true
    end

    it 'returns false if tickets are not available' do
      # Assuming event is fully booked
      event.update(booked_tickets: event.total_tickets)
      expect(controller.tickets_are_available?(ticket, event)).to be false
    end
  end
end