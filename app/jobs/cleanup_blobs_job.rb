class CleanupBlobsJob < ApplicationJob
  queue_as :default

  def perform
    # Remove unlinked blobs from ActiveStorage
    ActiveStorage::Blob.unattached.find_each(&:purge)
  end
end

