require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#session_expired?' do
    context 'when the session is expired' do
      it 'returns true' do
        session[:last_activity_time] = (Time.current - 3.hours).to_s # Assuming the session expired 3 hours ago
        expect(subject.send(:session_expired?)).to eq(true)
      end
    end

    context 'when the session is not expired' do
      it 'returns false' do
        session[:last_activity_time] = (Time.current - 1.hour).to_s # Assuming the session was active 1 hour ago
        expect(subject.send(:session_expired?)).to eq(false)
      end
    end
  end
end