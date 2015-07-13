class GeolocationsController < ApplicationController

  def pharmacies
    render_json
  end

  def wet_and_dry_wastes
    render_json
  end

  def hazardous_wastes
    data = Waste.hazardous_wastes.where(date: Time.now..Setting[:hazardous_days_home].days.from_now) do |waste|
      [ [ waste.street, waste.data[:info], waste.pretty_date ].compact.join("\n"), waste.latitude, waste.longitude ]
    end
    render json: data
  end

  def bulky_wastes
    render_json
  end

  def packaging_wastes
    render_json
  end

  private

  def render_json
    render json: Waste.public_send(action_name).pluck(:street, :latitude, :longitude)
  end
end
