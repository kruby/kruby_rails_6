class Voucher < ApplicationRecord
  
    belongs_to :partner

    #scope :last_year_first_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'") }
    scope :last_year_first_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'")}
    #scope :last_year_last_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'") }
    scope :last_year_last_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'")}

    #scope :this_year_last_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'") }
    scope :this_year_last_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'")}
    #scope :this_year_first_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'") }
    scope :this_year_first_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'")}

    scope :year, ->(this_year) {where("date BETWEEN '#{DateTime.new(this_year).beginning_of_year}' AND '#{DateTime.new(this_year).end_of_year}'")}

    def self.turnover_total
      self.sum{|v| v.number.to_f * v.hourly_rate.to_f}
    end

    def self.hours_total
      self.sum('number') rescue nil
    end

    def self.average_hourly_rate
      turnover_total / hours_total
    end

    def self.average_hourly_rate_partner partner
      turnover_total = partner.vouchers.select('sum(vouchers.number * vouchers.hourly_rate) as turnover_total')[0][:turnover_total]
      # [0][:turnover_total] betyder første række med valgte attribut der her er turnover_total. Beregning sker i database og ikke i Ruby og på den måde spare hukommelse.
      hours_total = partner.vouchers.sum(:number)
      average_hourly_rate = turnover_total / hours_total
      return average_hourly_rate.to_f
    end

    def self.average_hourly_rate_partner_year partner, year
      if partner.vouchers.year(year).blank?
        # Hvis ikke der er oprettet en voucher i indeværende år, henter den prisen på den seneste voucher.
        turnover_total = partner.vouchers.year(year-1).select('sum(vouchers.number * vouchers.hourly_rate) as turnover_total')[0][:turnover_total]
        average_hourly_rate = partner.vouchers.last.hourly_rate
        return average_hourly_rate.to_f
      else
        turnover_total = partner.vouchers.year(year).select('sum(vouchers.number * vouchers.hourly_rate) as turnover_total')[0][:turnover_total]
        # [0][:turnover_total] betyder første række med valgte attribut der her er turnover_total. Beregning sker i database og ikke i Ruby og på den måde spares hukommelse.
        hours_total = partner.vouchers.year(year).sum(:number)
        average_hourly_rate = turnover_total / hours_total
        return average_hourly_rate.to_f
      end
    end

  
  end

