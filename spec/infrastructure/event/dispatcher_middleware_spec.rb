# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::DispatcherMiddleware do
  EVENT_TYPE = 'counted'

  it 'should redirect event from command to event bus' do
    double = double(call: nil)
    event_bus = Event::Bus.new([MockEventCaptor.new(double)])
    event_dispatcher = Event::DispatcherMiddleware.new(event_bus)

    call_params = "call_params"
    events = [MockEvent.new(call_params), { lala: 'zaza', type: 'OTHER' }]
    command_bus = Command::Bus.new([MockUseCase.new(events)], [event_dispatcher])

    command = MockUseCaseCommand.new
    command_bus.send(command)

    expect(double).to have_received(:call).with(call_params)
  end

  class MockUseCaseCommand; end

  class MockUseCase < Command::UseCase
    def initialize(events)
      @events = events
    end

    def call(params)
      Command::Response.new(params, @events)
    end

    def listen_to
      MockUseCaseCommand
    end
  end

  class MockEvent
    attr_reader :params

    def initialize(params)
      @params = params
    end
  end

  class MockEventCaptor < Event::Captor
    def initialize(double)
      @double = double
    end

    def call(event)
      @double.call(event.params)
    end

    def event_type
      MockEvent
    end
  end
end
