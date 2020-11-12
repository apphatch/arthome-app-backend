module HashNormalizable
  def normalize hash
    hash.each do |k, v|
      hash[k] = nil if v == 'undefined'
    end
    return hash
  end
end
