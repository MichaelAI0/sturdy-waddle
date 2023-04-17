class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    token, options = token_and_options(request.headers["Authorization"])
    @current_user = User.find_by(token: token)
    @current_user
  end

  def render_unauthorized
    logger.debug "*** UNAUTHORIZED REQUEST: '#{request.env["HTTP_AUTHORIZATION"]}' ***"
    self.headers["WWW-Authenticate"] = 'Token realm="Application"'
    render json: { error: "Bad credentials" }, status: 401
  end

  private

  def token_and_options(header)
    strategy, token, options = header.to_s.split(" ")
    [token, options]
  end
end
