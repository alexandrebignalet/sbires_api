class Event::DispatcherMiddleware
  def initialize(event_bus)
    @event_bus = event_bus
  end

  def intercept(params, next_middleware)
    result = next_middleware.call

    @event_bus.publish(result.events)

    result
  end
end