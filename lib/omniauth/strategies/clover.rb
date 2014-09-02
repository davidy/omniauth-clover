require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Clover < OmniAuth::Strategies::OAuth2

      option :name, 'clover'

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.

      option :client_options, {
        :site           => 'https://www.clover.com',
        :authorize_url  => '/oauth/authorize',
        :token_url      => '/oauth/token'
      }

      option :authorize_options, [:redirect_uri, :response_type, :state]


      # After successful authentication, client information is returned
      #
      # Response parameters
      # -------------------
      #   merchant_id:  An ID that uniquely identifies the merchant who has authenticated with your app.
      #
      #   employee_id:  The employee ID of the current user. You can use this value to identify whether 
      #                 the current user is the owner of the merchant account, an employee, or someone else.
      #
      #   client_id:    The application ID that the user is authenticated to. If your app supports multiple 
      #                 markets (and you specified the client_ids parameter in the request to /oauth/authorize, 
      #                 then use this value to determine which of your apps the user authenticated against.
      #
      #   code:         Authorization code.
      #
      #
      # Employee Information
      # --------------------
      # Retrieves information for single employee
      #
      #   id (string, optional):                    Unique identifier
      #   name (string):                            Full name of the employee
      #   email (string, optional):                 Email of the employee (optional)
      #   pin (string, optional):                   Employee PIN (hashed)
      #   role (string, optional):                  ['ADMIN' or 'MANAGER' or 'EMPLOYEE']: Employee System Role
      #
      #   roles (array[Reference], optional)
      #   customId (string, optional):              Custom ID of the employee
      #   shifts (array[Reference], optional):      This employee's shifts
      #   nickname (string, optional):              Nickname of the employee (shows up on receipts)
      #   unhashedPin (string, optional):           Employee PIN
      #   payments (array[Reference], optional):    This employee's payments
      #   inviteSent (boolean, optional):           Returns true if this employee was sent an invite to activate their account
      #   isOwner (boolean, optional):              Returns true if this employee is the owner account for this merchant
      #   orders (array[Reference], optional):      This employee's orders
      #   claimedTime (long, optional):             Timestamp of when this employee claimed their account

      uid { 
        raw_info['id'] 
      }

      info do 
        {
          :name         => raw_info['name'],
          :first_name   => first_name,
          :last_name    => last_name,
          :email        => raw_info['email'],
          :role         => raw_info['role'],
          :urls         => { 'Clover' => raw_info['href'] }
        }
      end

      extra do 
        {
          :merchant_id  => request.params['merchant_id'],
          :employee_id  => request.params['employee_id'],
          :client_id    => request.params['client_id'],
          :code         => request.params['code']
        }
      end

      def raw_info
        merchant_id   = request.params['merchant_id']
        empployee_id  = request.params['employee_id']
        @raw_info ||= access_token.get("/v3/merchants/#{merchant_id}/employees/#{empployee_id}").parsed
      end


      private

      def first_name
        @raw_info['name'].blank? ? "" : @raw_info['name'].split(' ').first
      end

      def last_name
        @raw_info['name'].blank? ? "" : @raw_info['name'].split[1..-1].join(' ')
      end
    end
  end
end