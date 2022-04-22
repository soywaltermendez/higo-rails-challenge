require "rails_helper"

describe InvoiceMailer  do
  describe "invite" do

    before(:each) do
      @email ="test@test.com"
    end

    context "headers" do
      it "renders the subject" do
        mail = described_class.confirmation(@email)

        expect(mail.subject).to eq I18n.t("invoice_mailer.confirmation.subject")
      end

      it "sends to the right email" do
        mail = described_class.confirmation(@email)

        expect(mail.to).to eq [@email]
      end

      it "renders the from email" do
        mail = described_class.confirmation(@email)

        expect(mail.from).to eq ["from@example.com"]
      end
    end
  end
end