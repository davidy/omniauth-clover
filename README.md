# Omniauth::Clover

Clover OAuth2 Strategy for OmniAuth.

Supports the OAuth 2.0 server-side and client-side flows. For more information: https://www.clover.com/docs/oauth


## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-clover'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-clover

## Usage

Integrates with Devise authentication:

1) add to your config/initializers/devise.rb

    config.omniauth :clover, "APP_ID", "APP_SECRET"

client_options: (optional)
- site: defaults to the production https://www.clover.com
- authorize_url: defaults to '/oauth/authorize'
- token_url: defaults to '/oauth/token'

example: config.omniauth :clover, "APP_ID", "APP_SECRET", :client_options => {:site => 'https://dev.server.com'}

2) make your user model omniauthable

    devise :omniauthable, :omniauth_providers => [:clover]
    
3) once your user model is omniauthable and if your devise_for :user was added to config/routes.rb, you will have the following routes available:

    user_omniauth_authorize_path(provider)
    user_omniauth_callback_path(provider)
    
4) create sign in link

    <%= link_to "Sign in with Clover", user_omniauth_authorize_path(:clover) %> 
    
5) callback

    class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
        def clover
            # @omniauth will have the following json available:
            # 
            # {
            #   "provider"=>"clover", 
            #   "uid" => "", 
            #   "info" => {
            #       "name" => "", "first_name"=> "", "last_name"=>"", "email"=>"", "role"=>"", 
            #       "urls" => {
            #       "Clover"=>"https://..."}
            #   }, 
            #   "credentials" => {"token"=>"", "expires"=>false}, 
            #   "extra" => {"merchant_id"=>"", "employee_id"=>"", "client_id"=>"", "code"=>""}
            # }
            @omniauth = request.env['omniauth.auth'].to_hash

            ...
        end
    end

Please visit: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview for more information.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
