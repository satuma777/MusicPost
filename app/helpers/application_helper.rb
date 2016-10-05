module ApplicationHelper
    def resource_name
       :user
    end

    def resource
       @resource ||= User.new
    end

    def devise_mapping
       @devise_mapping ||= Devise.mappings[:user]
    end

    def current_user?(user)
        current_user.id == user.id
    end
end
