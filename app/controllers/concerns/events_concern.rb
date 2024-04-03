module EventsConcern
  # to show only those events which are created by current user
  def my_events
    user = User.find_by(id: params[:user_id])
    @events = user.events
  end

  # to show those events for which current user has booked tickets
  def booked_events
    user = User.find_by(id: params[:user_id])
    events_ids = user.tickets.pluck(:event_id).uniq
    @events = Event.where(id: events_ids)
  end

  # to check if there are tickets available for a particular event
  def tickets_are_available?(ticket, event)
    ticket_count = ticket.quantity
    booked_tickets = event.booked_tickets
    total_tickets = event.total_tickets
    (total_tickets - (ticket_count + booked_tickets)) >= 0 ? true : false
  end
end