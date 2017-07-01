class Device < ApplicationRecord
  AUDIO_MIME_TYPE_REGEX = /\Aaudio\/.*\z/

  has_attached_file :theme_song

  after_commit :play_theme_song, if: :just_connected?

  validates :mac_addr, presence: true, uniqueness: true
  validates :theme_song, attachment_content_type: { content_type: AUDIO_MIME_TYPE_REGEX }, attachment_size: { less_than: 5.megabytes }

  scope :having_theme_song, -> { where.not(theme_song_file_name: nil) }
  scope :connected, -> { where.not(current_ip_addr: nil) }

  def connected?
    current_ip_addr?
  end

  def theme_song?
    theme_song.present?
  end

  def play_theme_song
    PlayDeviceThemeSongJob.perform_later(self) if theme_song?
  end

  def theme_song_file_path
    theme_song.path if theme_song?
  end

  def display_name
    if name?
      "#{human_network_name} (#{name})"
    else
      human_network_name
    end
  end

  def human_network_name
    if current_ip_addr?
      current_ip_addr
    else
      mac_addr
    end
  end

  private

  def just_connected?
    current_ip_addr_was, current_ip_addr = saved_changes[:current_ip_addr]
    current_ip_addr_was.blank? && current_ip_addr.present?
  end
end
