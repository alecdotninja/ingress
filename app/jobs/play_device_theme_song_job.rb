class PlayDeviceThemeSongJob < ApplicationJob
  def perform(device)
    if device.theme_song?
      SoundPlayer.play(sound_file_path: device.theme_song_file_path)
    end
  end
end