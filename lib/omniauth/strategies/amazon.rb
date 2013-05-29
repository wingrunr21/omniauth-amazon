require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Amazon < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://www.amazon.com/',
        :authorize_url => 'https://www.amazon.com/ap/oa',
        :token_url => 'https://api.amazon.com/auth/o2/token'
      }

      option :access_token_options, {
        :mode => :query,
        :param_name => 'access_token'
      }

      option :authorize_params, {
        :scope => 'profile postal_code'
      }

      def request_phase
        super
      end

      def build_access_token
        token_params = {
          :redirect_uri => callback_url,
          :client_id => client.id,
          :client_secret => client.secret
        }
        verifier = request.params['code']
        client.auth_code.get_token(verifier, token_params)
      end

      uid { raw_info.parsed['user_id'] }

      info do
        {
          'email' => raw_info.parsed['email'],
          'name' => raw_info.parsed['name']
        }
      end

      extra do
        {
          'postal_code' => raw_info.parsed['postal_code']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/ap/user/profile').parsed
      end

    end
  end
end
