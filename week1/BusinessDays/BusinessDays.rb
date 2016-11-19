require 'Date'
require 'holidays'
require 'holidays/core_extensions/date'

class Date
  include Holidays::CoreExtensions::Date
end

class BusinessDays
  include Enumerable

  attr_reader :business_days

  def initialize(options = {})
    from = options.fetch(:start, Date.new(Date.today.year))
    to = options.fetch(:end_date, Date.today)
    locale = options.fetch(:region, :us)
    @business_days = [*from..to].reject { |d| d.holiday?(locale) }
  end

  def each(&block)
    @business_days.each(&block)
  end
end
