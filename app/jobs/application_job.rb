#!/usr/bin/ruby
# @Author: Nguyen The Thang
# @Date:   2016-10-21 01:42:00
# @Last Modified by:   Nguyen The Thang
# @Last Modified time: 2016-10-21 01:47:07
class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from(Exception) do |exception|
    puts "job exception"
    puts exception.inspect
    Raven.capture_exception(exception) if Raven
  end
end