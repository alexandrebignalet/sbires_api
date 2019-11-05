# frozen_string_literal: true

class Event::Bus
  def initialize(captors)
    @captors = captors
  end

  def publish(events)
    events.each(&method(:execute))
  end

  private

  def execute(event)
    @captors
      .select { |c| c.event_type.name == event.class.name }
      .map { |c| c.call(event) }
  end
end
