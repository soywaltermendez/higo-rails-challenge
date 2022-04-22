# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  def confirmation(email)
    mail(to: email, subject: I18n.t("invoice_mailer.confirmation.subject"))
  end
end
