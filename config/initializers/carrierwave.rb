CarrierWave.configure do |config|
  config.fog_credentials = {
     :provider                         => 'Google',
     :google_storage_access_key_id     => ENV['ASSET_KEY'],
     :google_storage_secret_access_key => ENV['ASSET_SECRET']
  }
  config.fog_directory = ENV['ASSET_BUCKET_NAME']
  config.asset_host = "//#{ENV['ASSET_BUCKET_NAME']}.storage.googleapis.com"
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
