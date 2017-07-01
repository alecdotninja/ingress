class NetworkScanJob < ApplicationJob
  def perform
    devices.each do |device|
      device.current_ip_addr = host_for_device(device)&.ip_addr
    end

    Device.transaction { devices.each(&:save!) }
  end

  private

  def devices
    @devices ||= new_devices + existing_devices
  end

  def new_devices
    new_device_mac_addrs.map { |mac_addr| Device.new(mac_addr: mac_addr) }
  end

  def new_device_mac_addrs
    host_mac_addrs - existing_device_mac_addrs
  end

  def existing_device_mac_addrs
    existing_devices.collect(&:mac_addr)
  end

  def existing_devices
    @existing_devices ||= Device.all.to_a
  end

  def host_mac_addrs
    hosts.collect(&:mac_addr)
  end

  def host_for_device(device)
    host_for_mac_addr(device.mac_addr)
  end

  def host_for_mac_addr(mac_addr)
    hosts.find { |host| host.mac_addr == mac_addr }
  end

  def hosts
    scan.hosts
  end

  def scan
    @scan ||= NetworkScanner.scan(network_scan_options)
  end

  def network_scan_options
    Rails.application.config_for(:network_scan).deep_symbolize_keys
  end
end