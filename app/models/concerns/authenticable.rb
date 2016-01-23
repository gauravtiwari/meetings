module Authenticable
  extend ActiveSupport::Concern
  included do
    has_many :identities, dependent: :destroy
  end

  class_methods do
    def find_for_oauth(auth, signed_in_resource = nil)
      # Get the identity and user if it exists
      identity = Identity.find_for_oauth(auth)
      # Else create the identity
      if identity.nil?
        identity = Identity.create_from_oauth(auth)
      end

      user = signed_in_resource ? signed_in_resource : identity.user
       # Create the user if needed
      if user.nil?
        email = auth.info.email
        user = User.where(:email => email).first if email
        # Create the user if it's a new registration
        if user.nil?
          user = User.new(
            name: auth.info.name,
            remote_avatar_url: auth.info.image.sub("_normal", ""),
            email: email,
            password: Devise.friendly_token[0,20]
          )
          user.skip_confirmation!
          user.confirmed_at = Time.now
          user.save!
        end
      end
      if identity.user != user
        identity.user = user
        identity.save!
      end
      user
    end
  end
end
