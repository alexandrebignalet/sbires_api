# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::Bus do
  it 'should call all the event listeners' do
    event_type = 'event_type'
    captor_one = double(call: nil, event_type: double(name: event_type))
    captor_two = double(call: nil, event_type: double(name: event_type))
    captor_three = double(call: nil, event_type: double(name: 'an_other'))
    listeners = [captor_one, captor_two, captor_three]

    events = [double(class: double(name: event_type)), double(class: double(name: event_type))]
    Event::Bus.new(listeners).publish(events)

    expect(captor_one).to have_received(:call).twice
    expect(captor_two).to have_received(:call).twice
    expect(captor_three).to_not have_received :call
  end
end
