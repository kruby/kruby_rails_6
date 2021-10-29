class UserMailer < ActionMailer::Base

  require 'icalendar'

  helper :application

  def deliver_ical_email(ics_event, partner)
    @ics_event = ics_event
    @partner = partner
    send_ical_email.deliver!
  end
  
  def send_ical_email
    mail.attachments['Kalender_aftale.ics'] = { :mime_type => 'text/calendar', :content => @ics_event }
    mail(:to => 'ts@kruby.dk', :subject => "Mødeaftale til din kalender", :from => "ts@kruby.dk")
  end


end
