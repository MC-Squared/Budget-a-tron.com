module DatesPageableByTimespan
  extend ActiveSupport::Concern

  included do
    before_action :set_timespan
    before_action :set_page
  end

  def get_dates_for_timespan_page(dates)
    dates ||= []
    return dates if @timespan == :all

    timespan_to_cover = timespan_sym_to_duration - 1.day
    start_date = Date.today - (@page * timespan_sym_to_duration)

    if @timespan != :all && dates.count > 0
      start_date = start_date - (timespan_to_cover - 1.days)
      dates = (start_date...(start_date + timespan_to_cover)).to_a
    end

    dates
  end

  def get_max_page(dates)
    return 0 if @timespan == :all
    (dates.last - dates.first).to_i.days / timespan_sym_to_duration
  end

  private

  def timespan_sym_to_duration
    duration = nil
    case @timespan
    when :year
      duration = 1.year
    when :month
      duration = 1.month
    when :fortnight
      duration = 2.weeks
    when :week
      duration = 1.week
    end

    duration
  end

  def set_timespan
    @timespan = params[:timespan]
    @timespan ||= :all
    @timespan = @timespan.to_sym
  end

  def set_page
    @page = params[:page]
    @page ||= 0
    @page = @page.to_i
  end
end
