class BaseLocationType < ApplicationRecord
  include BaseLocationTypeValidatable

  has_many :location_types, inverse_of: :base_location_type
  has_many :child_location_types, class_name: "LocationType", foreign_key: "base_location_type_id"
  enum depth_level: { residence: 1, place: 2, spot: 3 }  

  
end