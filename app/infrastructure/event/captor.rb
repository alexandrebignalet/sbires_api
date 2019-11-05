class Event::Captor
  def event_type
    raise "Event Captor must implement #{__callee__}"
  end
end