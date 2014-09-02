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

config.omniauth :clover, "APP_ID", "APP_SECRET", :client_options => {:site => SITE}

Please visit: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview for more information.

client options:
---------------
- site: Defaults to the production https://www.clover.com. Change SITE to point to the development server for testing.
- authorize_url: Defaults to '/oauth/authorize'
- token_url: Defaults to '/oauth/token' 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
