# frozen_string_literal: true
require 'open3'

class NetworkScanner
  class ScanError < StandardError; end

  def self.scan(*args)
    new(*args).scan
  end

  def self.arp_scan_bin
    @arp_scan_bin ||= `which arp-scan`.chomp.freeze
  end

  attr_reader :interface

  delegate :arp_scan_bin, to: :class

  def initialize(interface: nil)
    @interface = interface
  end

  def scan
    scan_time = Time.now
    arp_scan_output, status = Open3.capture2e(arp_scan_bin, *arp_scan_args)

    if status.success?
      Scan.new(time: scan_time, arp_scan_output: arp_scan_output)
    else
      raise ScanError, arp_scan_output
    end
  end

  private

  def arp_scan_args
    @arp_scan_args ||= [].tap do |cli_args|
      cli_args.push '--quiet'
      cli_args.push '--interface', interface if interface.present?
      cli_args.push '--localnet'
      cli_args.push '--retry', '10'
    end
  end
end