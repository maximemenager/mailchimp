defmodule Mailchimp.CampaignTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.Campaign
  alias Mailchimp.Campaign.Content

  doctest Campaign

  setup_all do
    HTTPoison.start()
  end

  describe "list/0" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    test "returns campaigns" do
      use_cassette "campaign.list", bypass: true do
        assert {:ok, [%Campaign{} | _]} = Campaign.list()
        assert [%Campaign{} | _] = Campaign.list!()
      end
    end
  end

  describe "content/1" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    test "returns campaign content" do
      use_cassette "campaign.list.content", bypass: true do
        assert [campaign | _] = Campaign.list!()
        assert {:ok, %Content{}} = Campaign.content(campaign)
        assert %Content{} = Campaign.content!(campaign)
      end
    end
  end

  describe "create/2" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    test "creates campaigns" do
      use_cassette "campaign.create", bypass: true do
        assert {:ok, %Campaign{type: :regular}} = Campaign.create(:regular)
        assert %Campaign{type: :regular} = Campaign.create!(:regular)
      end
    end
  end
end
