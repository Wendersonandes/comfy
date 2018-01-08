class Comfy::Cms::Subscription < ActiveRecord::Base
  self.table_name = 'comfy_cms_subscriptions'

  # -- Validations ----------------------------------------------------------
  validates :site_id, :presence   => true

  # -- Relationships --------------------------------------------------------
  belongs_to :site

  # -- Callbacks ------------------------------------------------------------

  # -- Scopes ---------------------------------------------------------------
  scope :subscribed, -> { where(:is_subscribed => true) }
  scope :not_subscribed, -> { where(:is_subscribed => false) }

	#TODO
	def set_not_subscribed
		if self.is_subscribed
		end
	end

end
