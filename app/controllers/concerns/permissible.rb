module Permissible
  def disallow roles
    render json: {error: 'you are not authorised to perform this action'} and return if @current_user.role.in?(roles)
  end
end
