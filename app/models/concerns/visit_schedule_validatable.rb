module VisitScheduleValidatable
  extend ActiveSupport::Concern

  included do
    validates :due_at, presence: true, if: -> { checklist&.is_planned }
    validates :due_at, absence: true, unless: -> { checklist&.is_planned }
    validate :cant_set_invalid_due_at, on: :update, unless: -> { skip_due_at_validation || !checklist&.is_planned }
    validate :cant_set_incompatible_place_and_checklist
    validate :single_location_relation
    validate :check_depth_level
  end

  private

  def cant_set_invalid_due_at
    errors.add(:due_at, I18n.t("validations.visit_schedule.invalide_due_at")) if due_at.nil? || due_at < DateTime.now
  end

  def cant_set_incompatible_place_and_checklist
    if !place.nil? && !checklist.nil? && (place.company_id != checklist.company_id)
      errors.add(:place, I18n.t("validations.visit_schedule.incompatible_place_and_checklist"))
    end 
  end

  def single_location_relation
    locations = %w[place_id residence_id spot_id]
    present_locations = locations.count { |attr| send(attr).present? }

    if present_locations != 1
      errors.add(:base, 'Une seule relation parmi place, residence, et spot doit être présente')
    end
  end

  def check_depth_level
    if place_id.present? && place.depth_level != 'Place'
      errors.add(:place, 'Le depth_level de la place doit être "Place"')
    elsif residence_id.present? && residence.depth_level != 'Residence'
      errors.add(:residence, 'Le depth_level de la residence doit être "Residence"')
    elsif spot_id.present? && spot.depth_level != 'Spot'
      errors.add(:spot, 'Le depth_level du spot doit être "Spot"')
    end
  end
  

end
