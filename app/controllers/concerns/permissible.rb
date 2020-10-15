module Permissible
  def disallow *roles
    render json: {error: 'you are not authorised to perform this action'} and return if @current_user.role.to_sym.in?(roles)
  end

  def allow *roles
    render json: {error: 'you are not authorised to perform this action'} and return unless @current_user.role.to_sym.in?(roles)
  end
end
