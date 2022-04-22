# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  def confirmation(email)
    mail(to: email, subject: "Processed invoices")
  end
end
