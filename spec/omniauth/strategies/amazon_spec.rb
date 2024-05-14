require 'spec_helper'

describe OmniAuth::Strategies::Amazon do
  subject do
    strategy = OmniAuth::Strategies::Amazon.new(nil, @options || {})
    strategy.stub(:session) { {  } }
    strategy
  end

  describe '#client' do
    it 'should have the correct Amazon site' do
      expect(subject.client.site).to eq("https://api.amazon.com/")
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

  describe '#raw_info' do
    let(:user_id) { 'amzn1.account.AHECIGNDVJG5QR6DRQFX5ZQVAOAA' }
    let(:user_name) { 'Philip Walsh' }
    let(:email) { 'pipwalshlx@gmail.com' }
    let(:response_body) { { "user_id" => user_id, "name" => user_name, "email" => email } }
    let(:response) { double(parsed: response_body) }

    let(:access_token) { 'some-token' }
    let(:client) { double(request: response) }

    before do
      allow_any_instance_of(OmniAuth::Strategies::Amazon).to receive(:access_token).and_return(
        double(options: {}, token: access_token, client: client)
      )
    end

    it 'calls the right Login with Amazon endpoint' do
      expect(client).to receive(:request).with(:get, "/user/profile", {
        params: { access_token: access_token }
      })
      expect(subject.raw_info).to eq(response_body)
    end

    context '#uid' do
      before do
        allow_any_instance_of(OmniAuth::Strategies::Amazon).to receive(:raw_info).and_return(response_body)
      end

      it 'extracts the Amazon user ID correctly' do
        expect(subject.uid).to eq(user_id)
      end
    end

    context '#info' do
      before do
        allow_any_instance_of(OmniAuth::Strategies::Amazon).to receive(:raw_info).and_return(response_body)
      end

      it 'extracts the Amazon user ID correctly' do
        expect(subject.info).to eq({'email' => email, 'name' => user_name})
      end
    end

    context '#extra' do
      before do
        allow_any_instance_of(OmniAuth::Strategies::Amazon).to receive(:raw_info).and_return(response_body)
      end

      it 'extracts the Amazon user ID correctly' do
        expect(subject.extra).to eq({'postal_code' => nil})
      end
    end
  end
end
