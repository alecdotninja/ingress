# frozen_string_literal: true
require 'open3'

class SoundPlayer
  class PlayError < StandardError; end

  def self.play(*args)
    new(*args).play
  end

  def self.play_bin
    @play_bin ||= `which play`.chomp
  end

  delegate :play_bin, to: :class

  attr_reader :sound_file_path

  def initialize(sound_file_path:)
    @sound_file_path = sound_file_path
  end

  def play
    play_output, status = Open3.capture2e(play_bin, '--no-show-progress', absolute_sound_file_path)

    if status.success?
      true
    else
      raise PlayError, play_output
    end
  end

  private

  def absolute_sound_file_path
    @absolute_sound_file_path ||= File.expand_path(sound_file_path)
  end
end