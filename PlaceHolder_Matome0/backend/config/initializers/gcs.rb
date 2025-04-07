require "google/cloud/storage"

GCS_CLIENT = Google::Cloud::Storage.new(
  project_id: "your-gcp-project-id", # 例: digest-with-ai
  credentials: Rails.root.join("config/credential/digest-with-ai-54977c53d6a2.json")
)