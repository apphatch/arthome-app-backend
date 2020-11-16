module Nameable
  def generate_name tokens, params={extension: ''}
    return tokens.map{|x| x.capitalize}.join << params[:extension]
  end

  def generate_salted_name tokens, params={extension: ''}
    name = generate_name tokens
    return name << "-#{Random.hex}" << params[:extension]
  end
end
