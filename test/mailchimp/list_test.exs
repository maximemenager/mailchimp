defmodule Mailchimp.ListTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.{Account, List, Member}
  alias Mailchimp.List.InterestCategory

  doctest List

  setup_all do
    HTTPoison.start()
  end

  describe "create_member/5" do
    test "creates member" do
      use_cassette "member.create", bypass: true do
        account = Account.get!()
        [list] = Account.lists!(account)

        {:ok, %Member{status: "subscribed", merge_fields: %{LNAME: "Test"}, language: "de"}} =
          List.create_member(
            list,
            "mailchimp1-test@elixir.com",
            "subscribed",
            %{LNAME: "Test"},
            %{
              language: "de"
            }
          )

        %Member{} =
          List.create_member!(
            list,
            "mailchimp1-test@elixir.com",
            "subscribed",
            %{LNAME: "Test"},
            %{language: "de"}
          )
      end
    end
  end

  describe "create_members/5" do
    test "creates members" do
      use_cassette "members.create", bypass: true do
        account = Account.get!()
        [list] = Account.lists!(account)

        {:ok, [%Member{status: "subscribed", merge_fields: %{LNAME: "Test"}, language: "de"}]} =
          List.create_members(
            list,
            ["mailchimp1-test@elixir.com"],
            "subscribed",
            %{LNAME: "Test"},
            %{
              language: "de"
            }
          )

        [%Member{}] =
          List.create_members!(
            list,
            ["mailchimp1-test@elixir.com"],
            "subscribed",
            %{LNAME: "Test"},
            %{language: "de"}
          )
      end
    end
  end

  describe "get_member/5" do
    test "gets member" do
      use_cassette "member.get", bypass: true do
        account = Account.get!()
        [list] = Account.lists!(account)

        {:ok, %Member{status: "subscribed", merge_fields: %{LNAME: "Test"}, language: "de"}} =
          List.get_member(list, "mailchimp1-test@elixir.com")

        %Member{} = List.get_member!(list, "mailchimp1-test@elixir.com")
      end
    end
  end

  describe "interest_categories/1" do
    test "returns list success" do
      use_cassette "interest_categories", bypass: true do
        account = Account.get!()
        [list] = Account.lists!(account)
        {:ok, [%InterestCategory{}]} = List.interest_categories(list)
        [%InterestCategory{}] = List.interest_categories!(list)
      end
    end
  end
end
