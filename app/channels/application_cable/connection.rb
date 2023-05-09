# frozen_string_literal: true

# This class is responsible for managing the WebSocket connections to the Action Cable server.
# It inherits from the `ActionCable::Connection::Base` class, and provides a connection object
# that can be used to perform various tasks related to the connection, such as subscribing to
# channels or broadcasting messages.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
  end
end
