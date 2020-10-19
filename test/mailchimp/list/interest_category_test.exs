defmodule Mailchimp.List.InterestCategoryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.{Account, List}
  alias Mailchimp.List.InterestCategory
  alias Mailchimp.List.InterestCategory.Interest

  doctest List

  setup_all do
    HTTPoison.start()
  end

  describe "interests/1" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    test "returns list success" do
      use_cassette "interests", bypass: true do
        account = Account.get!()
        [list] = Account.lists!(account)
        [category] = List.interest_categories!(list)
        {:ok, [%Interest{} | _]} = InterestCategory.interests(category)
        [%Interest{} | _] = InterestCategory.interests!(category)
      end
    end
  end
end
