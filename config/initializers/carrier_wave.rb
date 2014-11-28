CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => "AKIAIDRVW4BKYTBPURPA",
      :aws_secret_access_key  => "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",
      # :aws_access_key_id      => ENV['S3_KEY'],
      # :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'ap-southeast-1',
    }
    config.fog_directory  = "flixbucket"
  else
    config.storage = :file
    config.enable_processing = Rails.env.development? # If we're only running tests, we'll not use mini_magick to process the images.
  end
end