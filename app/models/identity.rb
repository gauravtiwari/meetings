class Identity < ApplicationRecord
  # Associations
  belongs_to :user, touch: true

  # Validations
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  # Class methods for creating and finding an identity
  def self.find_for_oauth(auth)
    where(
      uid: auth.uid,
      provider: auth.provider
    ).first
  end

  def self.create_from_oauth(auth)
    create(
      uid: auth.uid,
      provider: auth.provider,
      token: auth.credentials.token,
      secret: auth.credentials.secret
    )
  end
end
