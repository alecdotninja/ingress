class DevicesController < ApplicationController
  def index
    render :index, locals: { devices: devices }
  end
  
  def new
    render :new, locals: { device: device }
  end
  
  def create
    device.assign_attributes device_params
    
    if device.save
      redirect_to device_path(device), notice: "#{device.display_name} was created successfully."
    else
      render :new, locals: { device: device }, status: :unprocessable_entity
    end
  end
  
  def show
    render :show, locals: { device: device }
  end
  
  def edit
    render :edit, locals: { device: device }
  end
  
  def update
    device.assign_attributes device_params

    if device.save
      redirect_to device_path(device), notice: "#{device.display_name} was updated successfully."
    else
      render :edit, locals: { device: device }, status: :unprocessable_entity
    end
  end
  
  def destroy
    device.destroy
    
    if device.destroyed?
      redirect_to devices_path, notice: "#{device.display_name} was destroyed successfully."
    else
      redirect_to device_path(device), notice: device.errors.full_messages.to_sentence
    end
  end
  
  private
  
  def device
    @device ||=
      if params[:id].present?
        devices.find_by!(id: params[:id])
      else
        devices.new
      end
  end
  
  def device_params
    params.require(:device).permit(:mac_addr, :name, :theme_song)
  end
  
  def devices
    @devices ||= Device.order(name: :asc, current_ip_addr: :asc, mac_addr: :asc)
  end
end