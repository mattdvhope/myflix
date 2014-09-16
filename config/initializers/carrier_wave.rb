CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = { # Using environment variables
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['S3_KEY'],                # required
      :aws_secret_access_key  => ENV['S3_SECRET']              # required
    }
    config.fog_directory  = 'name_of_directory'                # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development? # If we're only running tests, we'll not use mini_magick to process the images.
  end
end