class Comfy::Cms::Site < ActiveRecord::Base
  self.table_name = 'comfy_cms_sites'

	PROFILE_URL_FORMATS = { 
		:youtube => /^(https?:\/\/)?(www\.)?youtube.com\/(channel\/|user\/)(?<channel>[^&]+)/,
		:facebook => /^(https?:\/\/)?(www\.)?facebook.com\/(?<profile>[^&]+)/,
		:soundcloud => /^(https?:\/\/)?(www\.)?soundcloud.com\/(?<profile>[^&]+)/,
		:instagram => /^(https?:\/\/)?(www\.)?instagram.com\/(?<profile>[^&]+)/
	}

  # -- Relationships --------------------------------------------------------
  with_options :dependent => :destroy do |site|
    site.has_many :layouts
    site.has_many :pages
    site.has_many :snippets
    site.has_many :files
    site.has_many :slides
    site.has_many :events
    site.has_many :galleries
    site.has_many :videos
    site.has_many :menus
    site.has_many :menu_items, :through => :menus
    site.has_many :images, :through => :galleries
    site.has_many :categories
  end

	belongs_to :user

  # -- Callbacks ------------------------------------------------------------
  before_validation :assign_identifier,
                    :assign_hostname,
                    :assign_label
  before_save :clean_path
  after_save  :sync_mirrors

  # -- Validations ----------------------------------------------------------
  validates :identifier,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with => /\A\w[a-z0-9_-]*\z/i }
  validates :label,
    :presence   => true
  validates :hostname,
    :presence   => true,
    :uniqueness => { :scope => :path },
    :format     => { :with => /\A[\w\.\-]+(?:\:\d+)?\z/ }

  # -- Scopes ---------------------------------------------------------------
  scope :mirrored, -> { where(:is_mirrored => true) }

  # -- Class Methods --------------------------------------------------------
  # returning the Comfy::Cms::Site instance based on host and path
  def self.find_site(host, path = nil)
    return Comfy::Cms::Site.first if Comfy::Cms::Site.count == 1
    cms_site = nil
    Comfy::Cms::Site.where(:hostname => real_host_from_aliases(host)).each do |site|
      if site.path.blank?
        cms_site = site
      elsif "#{path.to_s.split('?')[0]}/".match /^\/#{Regexp.escape(site.path.to_s)}\//
        cms_site = site
        break
      end
    end
    return cms_site
  end

  # -- Instance Methods -----------------------------------------------------
  def url
    public_cms_path = ComfortableMexicanSofa.config.public_cms_path || '/'
    '//' + [self.hostname, public_cms_path, self.path].join('/').squeeze('/')
  end

	def clean_youtube_profile
		match = PROFILE_URL_FORMATS[:youtube].match(self.youtube_profile)
		return match[:channel] if match
	end

	def clean_facebook_profile
		match = PROFILE_URL_FORMATS[:facebook].match(self.facebook_profile)
		return match[:profile] if match
	end

	def clean_instagram_profile
		match = PROFILE_URL_FORMATS[:instagram].match(self.instagram_profile)
		return match[:profile] if match
	end

	def clean_soundcloud_profile
		match = PROFILE_URL_FORMATS[:soundcloud].match(self.soundcloud_profile)
		return match[:profile] if match
	end

  # When removing entire site, let's not destroy content from other sites
  # Since before_destroy doesn't really work, this does the trick
  def destroy
    self.update_attributes(:is_mirrored => false) if self.is_mirrored?
    super
  end

protected

  def self.real_host_from_aliases(host)
    if aliases = ComfortableMexicanSofa.config.hostname_aliases
      aliases.each do |alias_host, aliases|
        return alias_host if aliases.include?(host)
      end
    end
    host
  end

  def assign_identifier
    self.identifier = self.identifier.blank?? self.hostname.try(:slugify) : self.identifier
  end

  def assign_hostname
    self.hostname ||= self.identifier
  end

  def assign_label
    self.label = self.label.blank?? self.identifier.try(:titleize) : self.label
  end

  def clean_path
    self.path ||= ''
    self.path.squeeze!('/')
    self.path.gsub!(/\/$/, '')
  end

  # When site is marked as a mirror we need to sync its structure
  # with other mirrors.
  def sync_mirrors
    return unless is_mirrored_changed? && is_mirrored?

    [self, Comfy::Cms::Site.mirrored.where("id != #{id}").first].compact.each do |site|
      site.layouts.reload
      site.pages.reload
      site.snippets.reload
      (site.layouts.roots + site.layouts.roots.map(&:descendants)).flatten.map(&:sync_mirror)
      (site.pages.roots + site.pages.roots.map(&:descendants)).flatten.map(&:sync_mirror)
      site.snippets.map(&:sync_mirror)
    end
  end

end
