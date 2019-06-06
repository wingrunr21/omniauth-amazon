require 'spec_helper'

describe OmniAuth::Strategies::Amazon do
  subject do
    strategy = OmniAuth::Strategies::Amazon.new(nil, @options || {})
    strategy.stub(:session) { {  } }
    strategy
  end

  describe '#client' do
    it 'should have the correct Amazon site' do
      expect(subject.client.site).to eq("https://www.amazon.com/")
    end

    it 'should have the correct authorization url' do
      expect(subject.client.options[:authorize_url]).to eq("https://www.amazon.com/ap/oa")
    end

    it 'should have the correct token url' do
      expect(subject.client.options[:token_url]).to eq('https://api.amazon.com/auth/o2/token')
    end
  end

  describe '#callback_path' do
    it 'should have the correct callback path' do
      expect(subject.callback_path).to eq('/auth/amazon/callback')
    end
  end

  describe '#callback_url' do
    it 'does not include query parameters' do
      allow(subject).to receive(:full_host).and_return('https://example.com')
      allow(subject).to receive(:script_name).and_return('/sub_uri')
      allow(subject).to receive(:query_string).and_return('?foo=bar')
      
       expect(subject.callback_url).to eq('https://example.com/sub_uri/auth/amazon/callback')
    end
  end
end
