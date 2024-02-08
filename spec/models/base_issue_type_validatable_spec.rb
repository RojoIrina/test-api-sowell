require 'rails_helper'

RSpec.describe BaseIssueType, type: :model do
  describe 'validations' do
    subject { build(:base_issue_type) }

    it { is_expected.to validate_presence_of(:name).with_message(I18n.t('activerecord.errors.models.base_issue_type.attributes.name.blank')) }
    it { is_expected.to validate_exclusion_of(:name).in_array(['']).with_message(I18n.t('activerecord.errors.models.base_issue_type.attributes.name.exclusion')) }

    it 'validates base_location_type parent of location_type' do
      subject.location_type = build(:location_type, base_location_type: build(:base_location_type))
      is_expected.to be_valid
    end

    it 'does not validate if base_location_type is not parent of location_type' do
      subject.location_type = build(:location_type, base_location_type: build(:base_location_type))
      subject.base_location_type = build(:base_location_type)
      is_expected.to_not be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:base_location_type) }
  end
end