module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def links_in_email(email)
    part = email.default_part
    if part.content_type =~ /text\/html/
      Nokogiri::HTML::Document.parse(part.body.to_s).search('a').map{|a| a[:href] }
    else
      URI.extract(part.body.to_s, ['http', 'https'])
    end
  end
end
