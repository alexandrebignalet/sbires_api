# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::DispatcherMiddleware do
  EVENT_TYPE = 'counted'
  LISTEN_TO = 'count'

  it 'should redirect event from command to event bus' do
    double = double(call: nil)
    event_bus = Event::Bus.new([MockEventCaptor.new(double)])
    event_dispatcher = Event::DispatcherMiddleware.new(event_bus)

    call_params = "call_params"
    events = [{ call_params: call_params, type: EVENT_TYPE }, { lala: 'zaza', type: 'OTHER' }]
    command_bus = Command::Bus.new([MockUseCase.new(events)], [event_dispatcher])

    command_bus.send(listen_to: LISTEN_TO)

    expect(double).to have_received(:call).with(call_params)
  end

  class MockUseCase
    def initialize(events)
      @events = events
    end

    def call(params)
      [params, @events]
    end

    def listen_to
      LISTEN_TO
    end
  end

  class MockEventCaptor
    def initialize(double)
      @double = double
    end

    def call(event)
      @double.call(event[:call_params])
    end

    def event_type
      EVENT_TYPE
    end
  end
end
