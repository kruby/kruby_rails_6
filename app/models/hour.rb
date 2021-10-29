class Hour < ApplicationRecord

        belongs_to :partner
        belongs_to :user

        validates_presence_of :partner

        #default_scope order('partner_id DESC, date DESC')
        #default_scope { order('partner_id DESC, date DESC') }

        #scope :timeliste, lambda { |partner_id| where(:partner_id => partner_id) }
        scope :timeliste, ->(partner_id) {where(partner_id: partner_id)}

        #scope :customer, lambda { |partner_id| where(:partner_id => partner_id) }
        scope :customer, ->(partner_id) {where(partner_id: partner_id)}

        #scope :monthly_hours, lambda { |this_month| where("date BETWEEN '#{this_month.to_datetime.beginning_of_month}' AND '#{this_month.to_datetime.end_of_month}'") }
        scope :monthly_hours, ->(this_month_date) {where("date BETWEEN '#{this_month_date.to_date.beginning_of_month}' AND '#{this_month_date.to_date.end_of_month}'") }

        #scope :yearly_hours, lambda { |this_year| where("date BETWEEN '#{this_year.to_datetime.beginning_of_year}' AND '#{this_year.to_datetime.end_of_year}'") }
        scope :yearly_hours, ->(this_year) {where("date BETWEEN '#{DateTime.new(this_year).beginning_of_year}' AND '#{DateTime.new(this_year).end_of_year}'")}

    scope :one_from_this_year, ->(this_year) {where("date BETWEEN '#{DateTime.new(this_year).beginning_of_year}' AND '#{DateTime.new(this_year).end_of_year}'")}


        #scope :last_year_first_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'") }
        scope :last_year_first_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'")}
        #scope :last_year_last_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'")}
        scope :last_year_last_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'")}


        #scope :this_year_last_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'") }
        scope :this_year_last_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year+6.months}' AND '#{this_date.to_datetime.end_of_year}'")}
        #scope :this_year_first_6_months, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'") }
        scope :this_year_first_6_months, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year}' AND '#{this_date.to_datetime.beginning_of_year+6.months-1.day}'")}

        #scope :last_3_years, lambda { |this_date| where("date BETWEEN '#{this_date.to_datetime.beginning_of_year-3.years}' AND '#{this_date.to_datetime.end_of_year}'") }
        scope :last_3_years, ->(this_date) {where("date BETWEEN '#{this_date.to_datetime.beginning_of_year-3.years}' AND '#{this_date.to_datetime.end_of_year}'")}

end