class Command::UseCase
  def listen_to
    raise StandardError, "A use case must implement #{__callee__}"
  end
end