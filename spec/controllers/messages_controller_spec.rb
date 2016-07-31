require 'rails_helper'

describe MessagesController do
  describe "GET #new" do
    subject { get :new }
    it "assigns a message" do
      subject
      expect(assigns[:message]).to be_a(Message)
      expect(assigns[:message]).to be_new_record
    end
    it { should render_template "messages/new" }
  end

  describe "POST #create" do
    subject { post :create, message: message_params }
    let(:message_params) do
      {
        sender: "test@example.com",
        recipient: "test2@example.com",
        body: "hello there"
      }
    end

    it "should make a new message" do
      expect { subject }.to change { Message.count }.by(1)
    end

    it "adds a message to the flash" do
      subject
      expect(flash[:message]).to_not be_nil
    end

    it { should redirect_to(new_message_path)}

    context "without a body" do
      let(:message_params) {{
        sender: "test1@example.com",
        recipient: "test2@example.com",
        body: nil
      }}
      it { should render_template("messages/new")}
      it "shows errors on the message" do
        subject
        expect(assigns[:message].errors).to be_present
      end
    end

    context "without a recipient" do
      let(:message_params) {{
        sender: "+14155551212",
        recipient: nil,
        body: "Hello"
      }}
      it { should render_template("messages/new")}
      it "shows errors on the message" do
        subject
        expect(assigns[:message].errors).to be_present
      end
    end

    context "without an invalid sender" do
      let(:message_params) {{
        sender: "neither number or mail",
        recipient: "test2@example.com",
        body: "Hi there"
      }}
      it { should render_template("messages/new")}
      it "shows errors on the message" do
        subject
        expect(assigns[:message].errors).to be_present
      end
    end

    context "without an invalid recipient" do
      let(:message_params) {{
        sender: "test2@example.com",
        recipient: "Neither number nor mail",
        body: "Hi there"
      }}
      it { should render_template("messages/new")}
      it "shows errors on the message" do
        subject
        expect(assigns[:message].errors).to be_present
      end
    end
  end
end
