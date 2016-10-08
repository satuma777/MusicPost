class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  include ApplicationHelper
  #↑viewからはhelperを自由に呼び出せるが、コントローラーから呼び出す時は、includeしなくてはならない。
  #↑すべてのコントローラはApplicationControllerを継承しているので、ApplicationControllerで定義したものはすべてのコントローラーに適用される。
  
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  #↑:devise_contoller?とはdeviseを生成した際にできるヘルパーメソッドの一つで、deviseにまつわる画面に行った時に、という意味がある。
  #↑こうすることで全ての画面でconfigure_permitted_parametersをするのを防いでいるのである。
  after_action  :store_location

    def after_sign_in_path_for(resource) 
        user_url(resource)
    end

    def after_sign_out_path_for(resource)
        root_path
    end

  private
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    #↑deviseの新規登録フォームでnameを受け取れるようにしている
    #↑devise4.1.0以降で、devise_parameter_sanitizer.forからdevise_parameter_sanitizer.permitに変更された
  end

  #def configure_permitted_parameters
     #devise_parameter_sanitizer.permit(:sign_up){|u|
      #u.permit(:name)
    #}
  #end 
  #↑これもnameを追加するために使えると書いてある記事があったが、残念ながらこれを使うと常にバリデーションエラーとなる。
  
  def store_location
  #↓直前のURLを保存しておく。
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
       #↑.fullpathとすると、requestオブジェクトに入っているurlを取ることができる。
    end
  end

  def after_sign_in_path_for(resource)
  #↓ログイン後は保存しておいたURLに飛ぶようにする。
    session[:previous_url] || root_path
  end

end
