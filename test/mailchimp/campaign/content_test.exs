defmodule Mailchimp.Campaign.ContentTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.Campaign
  alias Mailchimp.Campaign.Content

  doctest Campaign

  setup_all do
    HTTPoison.start()
  end

  describe "update/2" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    @tag :skip
    test "updates content" do
      use_cassette "content.update", bypass: true do
        assert [campaign | _] = Campaign.list!()
        assert content = Campaign.content!(campaign)

        # NOTE: This fails because the "links" inside the campaign reference the web_id property which always returns a 404 when accessed via the Mailchimp API

        assert {:ok, %Content{}} =
                 Content.update(content, %{
                   template: %{id: 2_000_122, sections: %{content: "Fooooobar"}}
                 })

        assert %Content{} =
                 Content.update!(content, %{
                   template: %{id: 2_000_122, sections: %{content: "Fooooobar"}}
                 })
      end
    end
  end
end
