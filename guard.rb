#!/usr/bin/env ruby
# frozen_string_literal: true

ENV.delete('RUBYLIB')
ENV.delete('RM_INFO')

exec 'bundle exec guard'
