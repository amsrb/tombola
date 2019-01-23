#!/usr/bin/env ruby
require "net/http"
require "json"
require "dotenv"
Dotenv.load

class Sweepstake
  ORGANISERS = [
    'Floor Drees',
    'Arno Fleming',
    'Rayta van Rijswijk',
    'Tom de Bruijn'
  ].freeze

  def self.pick(amount)
    sig_id = ENV["MEETUP_SIG_ID"]   || "141119542"
    begin
      event_id  = ENV.fetch("MEETUP_EVENT_ID")
      sig       = ENV.fetch("MEETUP_SIG")
    rescue
      puts "You need to provide a MEETUP_SIG env var signature to talk to Meetup. See https://secure.meetup.com/meetup_api/console/ for the proper values"
      return
    end
    endpoint = "https://api.meetup.com/Amsterdam-rb/events/#{event_id}/rsvps?photo-host=public&sig_id=#{sig_id}&response=yes&only=member.name&sig=#{sig}"

    names = JSON.parse(Net::HTTP.get(URI(endpoint))).map { |rsvp| rsvp["member"]["name"] }

    members = names.reject!(&method(:organiser?))

    members.sample(amount)
  end

  def self.organiser?(name)
    ORGANISERS.include?(name)
  end
end

puts Sweepstake.pick(4)
