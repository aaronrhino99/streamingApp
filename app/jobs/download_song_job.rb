class DownloadSongJob < ApplicationJob
  queue_as :default

  def perform(video_id, user_id)
    user = User.find(user_id)
    DownloadConvertService.new(video_id: video_id, user: user).call
  end
end

