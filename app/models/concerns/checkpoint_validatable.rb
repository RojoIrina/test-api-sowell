# frozen_string_literal: true

module CheckpointValidatable
  extend ActiveSupport::Concern

  included do
    validates :question, presence: { message: I18n.t("validations.checkpoint.question_presence") }
    validate :cannot_set_incompatible_issue_type_and_checklist
    validate :single_location_relation
    validate :correct_depth_level
  end

  private

  def cannot_set_incompatible_issue_type_and_checklist
    if !issue_type.nil? && !checklist.nil? && (issue_type.company_id != checklist.company_id)
      errors.add(:place, I18n.t("validations.checkpoint.incompatible_issue_type_and_checklist"))
    end
  end

  def single_location_relation
    location_relations = [spot_id, place_id, residence_id].compact
    errors.add(:base, 'must have only one location relation') unless location_relations.length == 1
  end

  def correct_depth_level
    location_id = spot_id || place_id || residence_id
    return if location_id.nil?

    location_type = LocationType.find_by(id: location_id)
    return if location_type.blank?

    expected_depth_level = location_type.base_location_type.depth_level.to_s
    errors.add(:base_location_type, "depth_level must correspond to the specified location (#{expected_depth_level})") unless location_type.depth_level == expected_depth_level
  end
end
