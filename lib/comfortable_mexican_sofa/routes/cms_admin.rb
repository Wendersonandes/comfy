class ActionDispatch::Routing::Mapper

  def comfy_route_cms_admin(options = {})
    options[:path] ||= 'admin'

    scope :module => :comfy, :as => :comfy do
      scope :module => :admin do
        namespace :cms, :as => :admin_cms, :path => options[:path], :except => :show do
          get '/', :to => 'base#jump'
          resources :sites do
						mount ImageUploader::UploadEndpoint, :at => "/attachments/image"
            resources :pages do
              get  :form_blocks,    :on => :member
              get  :toggle_branch,  :on => :member
              put :reorder,         :on => :collection
              resources :revisions, :only => [:index, :show, :revert] do
                patch :revert, :on => :member
              end
            end
            resources :files do
              put :reorder, :on => :collection
            end
            resources :layouts do
              put :reorder, :on => :collection
              resources :revisions, :only => [:index, :show, :revert] do
                patch :revert, :on => :member
              end
            end
            resources :snippets do
              put :reorder, :on => :collection
              resources :revisions, :only => [:index, :show, :revert] do
                patch :revert, :on => :member
              end
            end
            resources :categories
						resources :menus do
              put :reorder, :on => :collection
							resources :menu_items do
								put :reorder, :on => :collection
							end
						end
						resources :events do
							put :reorder, :on => :collection
						end
						resources :videos do
							put :reorder, :on => :collection
						end
						resources :galleries do
							resources :images do
								put :reorder, :on => :collection
							end
							put :reorder, :on => :collection
						end
						resources :images, :only => [:index] 
						resources :slides do
							put :reorder, :on => :collection
						end
          end
        end
      end
    end
  end
end
