# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Command::Bus do
  let(:listen_name) { 'TestBus' }
  let(:use_case_listening) { double(call: nil, listen_to: listen_name) }
  let(:use_case_not_listening) { double(call: nil, listen_to: "#{listen_name}other") }

  it 'should call one the use case which is listening for the command' do
    use_cases = [use_case_listening, use_case_not_listening]

    Command::Bus.new(use_cases, []).send(hello: 'it\'s me', listen_to: listen_name)

    expect(use_case_listening).to have_received(:call)
    expect(use_case_not_listening).to_not have_received(:call)
  end

  let(:middleware_one) { FakeMiddleware.new }
  let(:middleware_two) { FakeMiddleware.new }
  let(:middleware_three) { FakeMiddleware.new }

  it 'should call all the middlewares registered' do
    params = { listen_to: listen_name }

    Command::Bus
      .new([use_case_listening], [middleware_one, middleware_two, middleware_three])
      .send(params)

    expect(middleware_one.params).to eq params
    expect(middleware_two.params).to eq params
    expect(middleware_three.params).to eq params
  end

  class FakeMiddleware
    attr_reader :params

    def initialize
      @params = nil
    end

    def intercept(params, next_middleware)
      @params = params
      next_middleware.call
    end
  end
end
