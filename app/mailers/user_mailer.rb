class UserMailer < ActionMailer::Base
  default from: "no-reply@perl-china.com"

  def notify(email_addr, content)
    @message = content
    @subject = '[Perl-China]New message for you!'
    mail to: email_addr
  end

end
