require "spec_helper"

describe "Deactivate user for failed charge" do
  let(:event_data) do
    {
      "id" => "evt_103r372cQjvRqDMdjKkOVUiL",
      "created" => 1397523948,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_103r372cQjvRqDMdZuNyEYWJ",
          "object" => "charge",
          "created" => 1397523948,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103r362cQjvRqDMdVu7JCiBj",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 4,
            "exp_year" => 2016,
            "fingerprint" => "obZLck7qMpB6wAgu",
            "customer" => "cus_3r2jpqliREE5D2",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_3r2jpqliREE5D2",
          "invoice" => nil,
          "description" => "fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3r37EJ07BZ7Lwe"
    }
  end

  it "deactivates user when web hook data from stripe for charge failed", :vcr do
    daddy = Fabricate(:user, customer_token: "cus_3r2jpqliREE5D2")
    post "/stripe_events", event_data
    expect(daddy.reload).not_to be_active
  end
end