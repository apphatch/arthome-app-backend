module Projectable
  # extends active records only
  def project *attrs, take: nil, compact: true, columnize: false
    if attrs.length == 1
      projection = self.all.collect{|record| record.send(attrs.first)}
    else
      projection = self.all.collect{|record| record.attributes.select{|k, v| k.to_sym.in?(attrs)}}
    end
    message = ["--> projection of #{attrs} for #{projection.length} records"]

    if take.present? && take > 0
      message << "take #{take}"
      projection = projection.slice(0, take) if take.present?
    end
    if compact
      message << "compacted"
      projection = projection.uniq
    end
    message << "columnized" if columnize
    projection = projection.collect{|element| element.nil? ? "---" : element}

    #display
    puts "\e[1m#{ message.join(", ") }\e[0m"
    if columnize
      projection.each do |element|
        line = ""
        element.each do |k, v|
          word = "#{k}: \e[1m#{v}\e[0m"
          # +2 invisible characters for bold font
          line << word + " "*(15 - (word.length+2) % 10)
        end
        puts line
      end
    else
      puts projection
    end

    return nil
  end
end
