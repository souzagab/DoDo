class DevicesController < ApplicationController
  def create
    device = current_user.registered_devices.find_or_initialize_by(endpoint: device_params[:endpoint])

    if device.new_record?
      device.assign_attributes(device_params)
      device.save!
    end

    head :created
  end

  private

  def device_params
    params.require(:device)
          .deep_transform_keys!(&:underscore)
          .permit(:endpoint, :expiration_time, keys: %i[auth p256dh])
  end
end
