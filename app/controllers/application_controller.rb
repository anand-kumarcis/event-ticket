class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_session_timeout

  private

  def check_session_timeout
    if session[:last_activity_time] && session_expired?
      reset_session
      flash[:alert] = "Your session has timed out. Please log in again."
      redirect_to new_user_session_path
    else
      session[:last_activity_time] = Time.current
    end
  end

  def session_expired?
    # Adjust the session timeout duration as needed.
    # debugger
    session_timeout_duration = 2.hours.to_i
    Time.current > (Time.zone.parse(session[:last_activity_time].to_s) + session_timeout_duration)
  end
end
