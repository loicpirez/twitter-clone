# frozen_string_literal: true

# This class is the base class for Action Cable channels in the application.
# Channels allow WebSocket connections to receive and transmit data in real time
# between the client and the server. This class provides a foundation for
# defining channels that encapsulate a specific functionality or feature of the
# application.
module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end
