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
							get :get_facebook_events, :on => :collection
							put :reorder, :on => :collection
						end
						resources :videos do
							get :get_videos_from_youtube, :on => :collection
							put :reorder, :on => :collection
						end
						resources :galleries do
							resources :images do
                post :trash, :on => :member
								put :reorder, :on => :collection
							end
							put :reorder, :on => :collection
						end
						resources :images, :only => [:index]  do
							get	:trash_index, :on => :collection
							post :recover, :on => :member
						end
						resources :slides do
							put :reorder, :on => :collection
						end
          end
        end
      end
    end
  end
end
