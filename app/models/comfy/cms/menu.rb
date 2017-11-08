class Comfy::Cms::Menu < ActiveRecord::Base
  self.table_name = 'comfy_cms_menus'
  
  #attr_accessible :label, :site_id, :identifier
  
  # -- Relationships --------------------------------------------------------
  belongs_to :site
  has_many :menu_items,
    :autosave   => true,
    :dependent  => :destroy
    
  # -- Callbacks ------------------------------------------------------------
  before_create     :assign_position

  # -- Validations ----------------------------------------------------------
  validates :site_id, 
    :presence   => true
  validates :label, 
    :presence   => true

  # -- Scopes ---------------------------------------------------------------
  default_scope -> { order('comfy_cms_menus.position') }
    
  # -- Class Methods --------------------------------------------------------
	def self.options_for_select(site)
		out = []
		site.menus.each do |amenu|
			out << [ "#{amenu.label}", amenu.id ]
		end
		return out.compact
	end

protected

  def assign_position
    max = Comfy::Cms::Menu.maximum(:position)
    self.position = max ? max + 1 : 0
  end
    
end
