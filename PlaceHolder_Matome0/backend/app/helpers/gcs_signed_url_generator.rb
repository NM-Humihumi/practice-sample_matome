class GcsSignedUrlGenerator
    BUCKET_NAME = Rails.application.config.gcs_bucket_name

    def self.generate_upload_url(path, content_type: "image/png", expires_in: 10.minutes)
      bucket = GCS_CLIENT.bucket(BUCKET_NAME)
      file = bucket.create_file(StringIO.new(""), path)
      file.signed_url(method: "PUT", content_type: content_type, expires: expires_in)
    end
  
    def self.generate_download_url(path, expires_in: 1.hour)
      bucket = GCS_CLIENT.bucket(BUCKEET_NAME)
      file = bucket.file(path)
      file&.signed_url(method: "GET", expires: expires_in)
    end
  end
  