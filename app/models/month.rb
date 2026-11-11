class Month
  include Comparable

  attr_reader :first_day

  def self.current
    new(Date.current)
  end

  def self.find(param)
    raise Date::Error unless param.to_s.match?(/\A\d{4}-\d{2}\z/)

    new(Date.strptime(param.to_s, "%Y-%m"))
  rescue Date::Error
    raise ActiveRecord::RecordNotFound, "Couldn't find Month '#{param}'"
  end

  def initialize(date)
    @first_day = date.to_date.beginning_of_month
  end

  def last_day
    first_day.end_of_month
  end

  def days
    first_day..last_day
  end

  def weeks
    (first_day.beginning_of_week(:sunday)..last_day.end_of_week(:sunday)).each_slice(7).to_a
  end

  def include?(date)
    days.cover?(date)
  end

  def previous
    Month.new(first_day.prev_month)
  end

  def next
    Month.new(first_day.next_month)
  end

  def name
    first_day.strftime("%B %Y")
  end

  def to_param
    first_day.strftime("%Y-%m")
  end

  def <=>(other)
    first_day <=> other.first_day if other.is_a?(Month)
  end
end
