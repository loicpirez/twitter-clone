# frozen_string_literal: true

# The `ApplicationHelper` module provides a helper method called `full_title`
# that returns the full title of a web page based on the `page_title`
# parameter passed to the method. If no page_title is passed,
# the method returns a default title specific
# to the "Ruby on Rails Tutorial Sample App".
module ApplicationHelper
  # Return the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_title.empty?
      base_title
    else
      ERB::Util.html_escape("#{page_title} | #{base_title}").to_s
    end
  end
end
