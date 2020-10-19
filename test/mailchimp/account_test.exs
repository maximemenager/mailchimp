defmodule Mailchimp.AccountTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.Account

  doctest Account

  setup_all do
    HTTPoison.start()
  end

  describe "get/0" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    test "returns error tuple on error" do
      use_cassette "account.error", bypass: true do
        assert {:error, _detail} = Account.get("/1234")

        assert_raise(MatchError, fn ->
          Account.get!("/1234")
        end)
      end
    end

    test "returns account on success" do
      use_cassette "account.get", bypass: true do
        assert {:ok, %Mailchimp.Account{}} = Account.get()
        assert %Mailchimp.Account{} = Account.get!()
      end
    end
  end

  describe "lists/1" do
    setup do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")
      :ok
    end

    test "returns list success" do
      use_cassette "account.lists", bypass: true do
        account = Account.get!()
        assert {:ok, [%Mailchimp.List{}]} = Account.lists(account)
        assert [%Mailchimp.List{}] = Account.lists!(account)
      end
    end
  end
end
