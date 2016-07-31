require 'rails_helper'

describe MessageCreator do
  let(:creator) { MessageCreator.new ActionController::Parameters.new(message: message_params) }

  describe "#ok?" do
    subject { creator.ok? }
    context "with email params" do
      let(:message_params) do
        {
          sender: "test@example.com",
          recipient: "test2@example.com",
          body: "hello there"
        }
      end
      it {should be_truthy}
      it "saves the message" do
        expect { subject }.to change { creator.message.new_record? }
      end
      it "sets a secure id" do
        expect { subject }.to change { creator.message.secure_id }
      end
      it "sends an email with a secure link" do
        expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to match(creator.message.secure_id)
        expect(email.body).to_not match(/hello there/)
      end
      it "does not save phone values" do
        expect {creator.message.recipient_email.to be_nil}
        expect {creator.message.sender_email.to be_nil}
      end
      it "Does not send an SMS" do
        expect(creator.sms_record).to_not be_present
      end
    end

    context "with sms params" do
      let(:message_params) do
        {
          sender: "15005550006",
          recipient: "4155551212",
          body: "hello there"
        }
      end
      it {should be_truthy}
      it "saves the message" do
        expect { subject }.to change { creator.message.new_record? }
      end
      it "sets a secure id" do
        expect { subject }.to change { creator.message.secure_id }
      end
      it "does not send email" do
        expect {creator.message.recipient_email.to be_nil}
        expect {creator.message.sender_email.to be_nil}
        expect { subject }.to_not change { ActionMailer::Base.deliveries.count }
      end
      it "sends an SMS with a secure link" do
        subject
        expect(creator.sms_record).to be_present
        expect(creator.sms_record).to be_a(Twilio::REST::Message)
        expect(creator.sms_record.to).to eq("+14155551212")
        expect(creator.sms_record.from).to eq("+15005550006")
        expect(creator.sms_record.body).to match(creator.message.secure_id)
        expect(creator.sms_record.body).to_not match(/hello there/)
      end
    end

    context "without sender params" do
      let(:message_params) {{
        sender: nil,
        recipient: "sad@example.com"
      }}
      it { should be_falsey }
      it "should not send email" do
        expect { subject }.to_not change { ActionMailer::Base.deliveries.count }
      end
      it "should not make a message" do
        expect { subject }.to_not change { Message.count }
      end
    end

    context "with bad recipient params" do
      let(:message_params) {{
        sender: "+14155551212",
        recipient: "Neither number nor email",
        body: "Nope"
        }}
        it { should be_falsey }
      it "should not send email" do
        expect { subject }.to_not change { ActionMailer::Base.deliveries.count }
      end
      it "should not make a message" do
        expect { subject }.to_not change { Message.count }
      end
    end

    context "with bad sender params" do
      let(:message_params) {{
        sender: "Neither number nor email",
        recipient: "+14155551212",
        body: "Nope"
        }}
        it { should be_falsey }
      it "should not send email" do
        expect { subject }.to_not change { ActionMailer::Base.deliveries.count }
      end
      it "should not make a message" do
        expect { subject }.to_not change { Message.count }
      end
    end

  end
end
