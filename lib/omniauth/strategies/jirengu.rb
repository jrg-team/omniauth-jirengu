require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Jirengu < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'http://user.jirengu.com',
        :authorize_url => '/oauth/authorize',
        :token_url => '/oauth/token'
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['uid'].to_s }

      info do
        {
          'nickname' => raw_info['name'],
          'name' => raw_info['real_name'],
          'image' => raw_info['avatar'],
          'email' => raw_info['email'],
          'gender' => raw_info['gender'],
          'birthday' => raw_info['bitrhday'],
          'school' => raw_info['school'],
          'location' => raw_info['location'],
          'company' => raw_info['company'],
          'bio' => raw_info['bio']
        }
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      def email
        raw_info['email']
      end
    end
  end
end

OmniAuth.config.add_camelization 'github', 'GitHub'
