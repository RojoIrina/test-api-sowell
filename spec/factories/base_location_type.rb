FactoryBot.define do
    factory :base_location_type do
        name { Faker::Lorem.word }  # générer un nom aléatoire
        depth_level { BaseLocationType.depth_levels.keys.sample }  # Sélection aléatoire d'une profondeur parmi les options disponibles
      association :location_type, factory: :location_type
    end
  end