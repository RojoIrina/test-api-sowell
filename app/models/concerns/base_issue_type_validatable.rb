module BaseIssueTypeValidatable
    extend ActiveSupport::Concern

    included do
      validates :name, presence: { message: I18n.t('activerecord.errors.models.base_issue_type.attributes.name.blank') },
                       exclusion: { in: [''], message: I18n.t('activerecord.errors.models.base_issue_type.attributes.name.exclusion') }
  
      belongs_to :base_location_type
  
      validate :base_location_type_parent_of_location_type
    end
  
    private
  
    def base_location_type_parent_of_location_type
      errors.add(:base_location_type, "should be the parent of location_type") unless base_location_type == location_type&.base_location_type
    end
  end