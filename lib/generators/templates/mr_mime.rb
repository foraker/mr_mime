MrMime.configure do |config|
  # Configure your user authentication adapter.
  # Supported adapters are :devise, :sorcery
  config.adapter = :devise

  # Configure the name of the user model used for authentication.
  config.user_model = 'User'

  # Configure the user method used for impersonation permission checks.
  # Your configured user model must respond to this method
  # If the method returns falsey, the user will not be permitted to impersonate
  # If the method returns truthy, the user will be permitted to impersonate
  # Default: nil
  # config.user_permission_check = :admin?

  # Configure the URL that users will be redirected to after beginning impersonation.
  # Accepts the following formats (with examples):
  #
  # -- String: A literal URL string
  # config.after_impersonation_url = '/'
  #
  # -- Proc/Lambda: Must return the desired URL. The impersonated user will be passed in.
  # config.after_impersonation_url = Proc.new { |impersonated| user_url(impersonated) }
  #
  # -- Symbol: The name of a URL helper method within your application
  config.after_impersonation_url = :root_url
end
