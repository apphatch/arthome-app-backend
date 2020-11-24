module Nameable
  def generate_name tokens, extension: ''
    return tokens.map{|x| x.camelcase}.join << extension
  end

  def generate_salted_name tokens, extension: ''
    name = generate_name tokens
    return name << "-#{Random.hex}" << extension
  end
end
