class Command::Response
  attr_reader :value, :events

  def initialize(value, events = [])
    @value = value
    @events = events
  end
end