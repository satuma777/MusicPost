class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  #↑:devise_contoller?とはdeviseを生成した際にできるヘルパーメソッドの一つで、deviseにまつわる画面に行った時に、という意味がある。
  #↑こうすることで全ての画面でconfigure_permitted_parametersをするのを防いでいるのである。

  private
  
  def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up){|u|
      u.permit(:name)
    }
    #↑deviseの新規登録フォームでnameを受け取れるようにしている
    #↑devise4.1.0以降で、devise_parameter_sanitizer.forからdevise_parameter_sanitizer.permitに変更された
  end 

end
