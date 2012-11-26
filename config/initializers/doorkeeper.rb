Doorkeeper.configure do
  # This block will be called to check whether the
  # resource owner is authenticated or not
  resource_owner_authenticator do |routes|
    # Put your resource owner authentication logic here.
    # If you want to use named routes from your app you need
    # to call them on routes object eg.
    # routes.new_user_session_path
    User.find_by_id(session[:user_id]) || redirect_to(routes.login_url(:return_to => request.fullpath))
  end

  # If you want to restrict the access to the web interface for
  # adding oauth authorized applications you need to declare the
  # block below
  admin_authenticator do |routes|
    # Put your admin authentication logic here.
    # If you want to use named routes from your app you need
    # to call them on routes object eg.
    # routes.new_admin_session_path
    (session[:user_id].present? &&
    User.find_by_id(session[:user_id]).role == 'admin') ||
      redirect_to(routes.root_path)
  end

  resource_owner_from_credentials do |routes|
    user = User.find_by_email(params[:username])
    user && user.authenticate(params[:password])
  end

  # Access token expiration time (default 2 hours).
  # If you want to disable expiration, set this to nil.
  # access_token_expires_in 2.hours

  # Issue access tokens with refresh token (disabled by default)
  # use_refresh_token

  # Define access token scopes for your provider
  # For more information go to https://github.com/applicake/doorkeeper/wiki/Using-Scopes
  # default_scopes  :public
  # optional_scopes :write, :update

  # Change the way client credentials are retrieved from the request object.
  # By default it retrieves first from `HTTP_AUTHORIZATION` header and
  # fallsback to `:client_id` and `:client_secret` from `params` object
  # Check out the wiki for mor information on customization
  # client_credentials :from_basic, :from_params
end
