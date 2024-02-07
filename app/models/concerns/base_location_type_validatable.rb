module BaseLocationTypeValidatable
    extend ActiveSupport::Concern
  
    included do
      validates :name, presence: { message: I18n.t('activerecord.errors.models.base_location_type.attributes.name.blank') },
                        exclusion: { in: [''], message: I18n.t('activerecord.errors.models.base_location_type.attributes.name.exclusion') }
      validates :depth_level, presence: { message: I18n.t('activerecord.errors.models.base_location_type.attributes.depth_level.blank') },
                              inclusion: { in: [1, 2, 3], message: I18n.t('activerecord.errors.models.base_location_type.attributes.depth_level.inclusion') }
  
      before_validation :set_default_depth_level
  
      private
  
      def set_default_depth_level
        self.depth_level ||= 1
      end
    end
  end

  