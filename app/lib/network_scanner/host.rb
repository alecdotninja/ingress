# frozen_string_literal: true
class NetworkScanner
  class Host
    attr_reader :ip_addr, :mac_addr

    def initialize(ip_addr:, mac_addr:)
      @ip_addr = ip_addr
      @mac_addr = mac_addr
    end

    def ==(other)
      case other
        when Host
          other.ip_addr == ip_addr && other.mac_addr == mac_addr
        else
          super
      end
    end

    def hash
      [ip_addr, mac_addr].hash
    end

    alias_method :eql?, :==
  end
end