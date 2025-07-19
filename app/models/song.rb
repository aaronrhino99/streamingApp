class Song < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :audio_file

  enum :status, { queued: 0, processing: 1, ready: 2, failed: 3 }

  validates :youtube_id, presence: true, length: { is: 11 }

  scope :recent, -> { order(created_at: :desc) }

  def audio_file_url
    return nil unless audio_file.attached?
    Rails.application.routes.url_helpers.rails_blob_url(audio_file, only_path: true)
  end
end
