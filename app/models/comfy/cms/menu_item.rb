class Comfy::Cms::MenuItem < ActiveRecord::Base
  self.table_name = 'comfy_cms_menu_items'
  #attr_accessible :label, :link, :menu_id, :page_id, :menu_item_type
  # -- Relationships --------------------------------------------------------
  belongs_to :menu
  
  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position


  # -- Validations ----------------------------------------------------------
  validates :menu_id, 
    :presence   => true
  validates :label, 
    :presence   => true
	#  validates :menu_item_type, 
	#    :presence   => true

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_menu_items.position') }
protected

  def assign_position
    max = Comfy::Cms::MenuItem.maximum(:position)
    self.position = max ? max + 1 : 0
  end
 
end
