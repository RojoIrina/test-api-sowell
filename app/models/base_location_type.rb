class BaseLocationType < ApplicationRecord
  include BaseLocationTypeValidatable

  has_many :location_types, inverse_of: :base_location_type
  accepts_nested_attributes_for :location_types

  has_many :child_location_types, class_name: "LocationType", foreign_key: "base_location_type_id"

  enum depth_level: { residence: 1, place: 2, spot: 3 }

  validates_associated :location_types  
end