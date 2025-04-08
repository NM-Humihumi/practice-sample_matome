module Api
    module V1
      class ImagesController < ApplicationController
        def presign
          filename = params[:filename] || params.dig(:image, :filename)
          path = generate_gcs_path(filename)
  
          url = GcsSignedUrlGenerator.generate_upload_url(path)
  
          render json: {
            upload_url: url,
            public_url: "https://storage.googleapis.com/#{Rails.application.config.gcs_bucket_name}/#{path}"
          }
        end
  
        private
  
        def generate_gcs_path(filename)
          date = Time.zone.today
          hash = SecureRandom.hex(10)
          "#{date.strftime('%Y/%m/%d')}/#{hash}/#{filename}"
        end
      end
    end
  end
  