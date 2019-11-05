# frozen_string_literal: true

class Command::Bus
  class UseCaseNotFound < StandardError; end

  def initialize(use_cases, middlewares)
    @use_cases = use_cases
    @middleware_chain = create_chain(middlewares)
  end

  def send(params)
    @middleware_chain.call(params)
  end

  private

  def create_chain(middlewares)
    middlewares.reduce(final_chain) do |sub_chain, middleware|
      Chain.new(middleware, sub_chain)
    end
  end

  def final_chain
    Chain.new(InvokeUseCase.new(@use_cases), nil)
  end

  class Chain
    def initialize(middleware, next_chain)
      @current = middleware
      @next_chain = next_chain
    end

    def call(params)
      @current.intercept(params, ->(){ @next_chain.call(params) })
    end
  end

  class InvokeUseCase
    def initialize(use_cases)
      @use_cases = use_cases.each_with_object({}) do |cur, acc|
        acc[cur.listen_to.name] = cur
        acc
      end
    end

    def intercept(command, _next_middleware)
      use_case = @use_cases[command.class.name]
      if use_case.nil?
        raise UseCaseNotFound, 'Use case associated with this command is not handle yet'
      end

      Rails.logger.info "#{use_case.class.name} handled #{command}"

      use_case.call(command)
    end
  end
end
