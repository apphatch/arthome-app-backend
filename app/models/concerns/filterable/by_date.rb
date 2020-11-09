module Filterable::ByDate
  # filters default to true unless parameters given
  # this is so they easily chain with && in exporters
  # as the filter can simply be bypassed

  def date_filter obj, params
    if params[:date_from].present? && params[:date_to].present? && obj.respond_to?(:date)
      return obj.date.between?(params[:date_from], params[:date_to])
    end
    return true
  end

  def yearweek_filter obj, params
    if params[:yearweek] && obj.respond_to?(:yearweek)
      return obj.yearweek == params[:yearweek].to_s
    end
    return true
  end
end
