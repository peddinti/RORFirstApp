module SessionsHelper
  def sign_in(user)
    # once the user signs in, we create a new remember token
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
  end
  
  def sign_out
    current_user.update_attribute(:remember_token,
                                      User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil                                  
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def current_user?(user)
    user==current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in"
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url, notice: "No permissions to access this page" unless current_user?(@user)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
