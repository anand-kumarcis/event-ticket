module EventsHelper
  def user_booked_tickets(event)
    quantity_array = current_user.tickets.where(event_id: event.id).pluck(:quantity)
    quantity_array.sum
  end

  def tickets_are_available?(event)
    (event.total_tickets - event.booked_tickets) > 0
  end

  def available_tickets_for_event(event)
    event.total_tickets - event.booked_tickets
  end

  def convert_time(time)
    time.present? ? Time.parse(time).strftime("%I:%M %p") : 'N/A'
  end

  def format_date(date)
    date.present? ? Time.parse(date.to_s).strftime("%d %B, %Y") : 'N/A'
  end
end
