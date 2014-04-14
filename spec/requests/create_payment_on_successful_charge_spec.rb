require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
 {
    "id" => "evt_103qv02cQjvRqDMdPMSq98Vh",
    "created" => 1397493765,
    "livemode" => false,
    "type"=> "charge.succeeded",
    "data" => {
      "object" => {
        "id" => "ch_103qv02cQjvRqDMdwh9vZmWe",
        "object" => "charge",
        "created" => 1397493765,
        "livemode" => false,
        "paid" => true,
        "amount" => 999,
        "currency" => "usd",
        "refunded" => false,
        "card" => {
          "id" => "card_103qv02cQjvRqDMdr8SoXsaV",
          "object" => "card",
          "last4" => "4242",
          "type" => "Visa",
          "exp_month" => 4,
          "exp_year"=> 2017,
          "fingerprint" => "3G2xcQ0kXYcONRa8",
          "customer" => "cus_3qv0gVXWZz6nfR",
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
        "captured" => true,
        "refunds" => [],
        "balance_transaction" => "txn_103qv02cQjvRqDMdqWPTDGHT",
        "failure_message" => nil,
        "failure_code" => nil,
        "amount_refunded" => 0,
        "customer" => "cus_3qv0gVXWZz6nfR",
        "invoice" => "in_103qv02cQjvRqDMd5YgDbczX",
        "description" => nil,
        "dispute" => nil,
        "metadata" => {},
        "statement_description" => nil
      }
    },
    "object" => "event",
    "pending_webhooks" => 1,
    "request" => "iar_3qv0OGmwO4Lll3"
  }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    daddy = Fabricate(:user, customer_token: "cus_3qv0gVXWZz6nfR")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(daddy)
  end

  it "creates the payment with the amount", :vcr do
    daddy = Fabricate(:user, customer_token: "cus_3qv0gVXWZz6nfR")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the patment with reference id", :vcr do
     daddy = Fabricate(:user, customer_token: "cus_3qv0gVXWZz6nfR")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103qv02cQjvRqDMdwh9vZmWe")
  end
end
