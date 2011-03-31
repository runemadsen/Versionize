require 'ungulate/file_upload'
Ungulate::FileUpload.access_key_id = Rails.application.config.access_key_id
Ungulate::FileUpload.secret_access_key = Rails.application.config.secret_access_key