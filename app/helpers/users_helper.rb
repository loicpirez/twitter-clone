# frozen_string_literal: true

# This is a helper module for the Users class that defines a method to return
# the Gravatar for a given user. The method uses the user's email to generate a
# unique gravatar URL using the MD5 hash function and the secure Gravatar service.
# The size of the gravatar can be customized using an optional size parameter,
# which defaults to 80 pixels. The method then returns an HTML img tag with the
# gravatar URL, alt text set to the user's name, and a CSS class of "gravatar".
module UsersHelper
  # Return the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
