class EventsController < ApplicationController
  include EventsConcern
  before_action :set_event, only: [:show, :edit, :update, :destroy, :book_ticket]

  def index
    @events = Rails.cache.fetch('all_events', expires_in: 5.minutes) do
      Event.all
    end
  end

  def show; end

  def new
    @event = Event.new
  end

  def edit; end

  def update
    if @event.update(event_params)
      flash[:notice] = "Event updated successfully"
      redirect_to @event
    else
      flash.now[:alert] = "Failed to update event"
      render :edit
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = "Event created successfully"
      redirect_to my_events_events_path(user_id: current_user.id)
    else
      flash.now[:alert] = "Failed to create event"
      render :new
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event deleted successfully"
    redirect_to events_path
  end

  # to book the ticket for an event
  def book_ticket
    user = current_user 
    ticket = Ticket.new(ticket_params)
    if tickets_are_available?(ticket, @event)
      ticket.save
      booked_ticket = @event.booked_tickets + ticket.quantity
      @event.update(booked_tickets: booked_ticket)
      flash[:notice] = "Tickets booked successfully"
    else
      flash.now[:alert] = "Failed to book tickets"
    end
    redirect_to event_path(@event.id)
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :date, :time, :total_tickets, :booked_tickets, :user_id)
  end

  def ticket_params
    params.permit(:quantity, :user_id, :event_id)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
