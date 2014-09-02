require 'spec_helper'
require 'omniauth-clover'

describe OmniAuth::Strategies::Clover do
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }
  let(:app) {
    lambda do
      [200, {}, ["Hello."]]
    end
  }

  subject do
    OmniAuth::Strategies::Clover.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client_options' do
    it 'has correct site' do
      expect(subject.client.site).to eq('https://www.clover.com')
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('/oauth/authorize')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('/oauth/token')
    end

    describe "overrides" do
      it 'should allow overriding the site' do
        @options = {:client_options => {'site' => 'https://example.com'}}
        expect(subject.client.site).to eq('https://example.com')
      end

      it 'should allow overriding the authorize_url' do
        @options = {:client_options => {'authorize_url' => 'https://example.com'}}
        expect(subject.client.options[:authorize_url]).to eq('https://example.com')
      end

      it 'should allow overriding the token_url' do
        @options = {:client_options => {'token_url' => 'https://example.com'}}
        expect(subject.client.options[:token_url]).to eq('https://example.com')
      end
    end
  end

  describe "#authorize_options" do
    [:redirect_uri, :response_type, :state].each do |k|
      it "should support #{k}" do
        @options = {k => 'http://someval'}
        expect(subject.authorize_params[k.to_s]).to eq('http://someval')
      end
    end

    describe "redirect_uri" do
      it 'should default to nil' do
        @options = {}
        expect(subject.authorize_params['redirect_uri']).to eq(nil)
      end

      it 'should set the redirect_uri parameter if present' do
        @options = {:redirect_uri => 'https://example.com'}
        expect(subject.authorize_params['redirect_uri']).to eq('https://example.com')
      end
    end

    describe 'response_type' do
      it 'should default to "code"' do
        @options = {}
        expect(subject.authorize_params['response_type']).to eq(nil)
      end

      it 'should set the response_type parameter if present' do
        @options = {:response_type => 'token'}
        expect(subject.authorize_params['response_type']).to eq('token')
      end
    end

    describe 'state' do
      it 'should set the state parameter' do
        @options = {:state => 'some_state'}
        expect(subject.authorize_params['state']).to eq('some_state')
        expect(subject.session['omniauth.state']).to eq('some_state')
      end
    end
  end

end
