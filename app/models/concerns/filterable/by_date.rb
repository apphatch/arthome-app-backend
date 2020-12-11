module Filterable::ByDate
  # filters default to true unless parameters given
  # this is so they easily chain with && in exporters
  # as the filter can simply be bypassed

  def updated_at_filter obj, date_from: nil, date_to: nil
    if date_from.present? && date_to.present? && obj.respond_to?(:updated_at)
      return obj.updated_at.between?(date_from, date_to)
    end
    return true
  end

  def created_at_filter obj, date_from: nil, date_to: nil
    if date_from.present? && date_to.present? && obj.respond_to?(:created_at)
      return obj.created_at.between?(date_from, date_to)
    end
    return true
  end

  def date_filter obj, date_from: nil, date_to: nil
    if date_from.present? && date_to.present? && obj.respond_to?(:date)
      return obj.date.between?(date_from, date_to)
    end
    return true
  end

  def yearweek_filter obj, yearweek: nil
    if yearweek && obj.respond_to?(:yearweek)
      return obj.yearweek == yearweek.to_s
    end
    return true
  end
end
