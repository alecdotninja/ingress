# frozen_string_literal: true
class NetworkScanner
  class Scan
    MAC_ADDRESS_REGEX = /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/

    attr_reader :time, :arp_scan_output

    def initialize(time: Time.now, arp_scan_output:)
      @time = time
      @arp_scan_output = arp_scan_output
    end

    def hosts
      @hosts ||= collect_hosts
    end

    private

    def collect_hosts
      arp_scan_output_lines.
        map { |line| line.split(/\t/)[0..2] }.
        map { |raw_ip_addr, raw_mac_addr| [parse_ip_addr(raw_ip_addr), parse_mac_addr(raw_mac_addr)] }.
        map { |ip_addr, mac_addr| Host.new(ip_addr: ip_addr, mac_addr: mac_addr) if ip_addr && mac_addr }.
        compact.
        uniq
    end

    def arp_scan_output_lines
      arp_scan_output.each_line
    end

    def parse_ip_addr(ip_addr)
      IPAddr.new(ip_addr) if ip_addr.present?
    rescue IPAddr::InvalidAddressError
      nil
    end

    def parse_mac_addr(mac_addr)
      mac_addr.chomp if mac_addr.present? && MAC_ADDRESS_REGEX.match?(mac_addr)
    end
  end
end