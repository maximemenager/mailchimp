defmodule Mailchimp.Config do
  @moduledoc """
  Mailchimp Config Module
  """

  @default_api_version "3.0"
  @default_api_endpoint "api.mailchimp.com"

  @doc """
  Return configured API Key

  ### Examples

      iex> Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      iex> Mailchimp.Config.api_key!()
      "your apikey-us12"
      iex> Application.delete_env(:mailchimp, :api_key)

  """
  @spec api_key!() :: String.t() | no_return
  def api_key!, do: Application.fetch_env!(:mailchimp, :api_key)

  @doc """
  Return configured API Version

  ### Examples

      iex> Application.put_env(:mailchimp, :api_version, "1.0")
      iex> Mailchimp.Config.api_version()
      "1.0"
      iex> Application.delete_env(:mailchimp, :api_version)

      iex> Application.delete_env(:mailchimp, :api_version)
      iex> Mailchimp.Config.api_version()
      "3.0"

  """
  @spec api_version() :: String.t()
  def api_version, do: Application.get_env(:mailchimp, :api_version, @default_api_version)

  @doc """
  Return configured API endpoint

  ### Examples

    iex> Application.put_env(:mailchimp, :api_endpoint, "api.mc.local")
    iex> Mailchimp.Config.api_endpoint()
    "api.mc.local"
    iex> Application.delete_env(:mailchimp, :api_endpoint)

    iex> Application.delete_env(:mailchimp, :api_endpoint)
    iex> Mailchimp.Config.api_endpoint()
    "api.mailchimp.com"

  """
  @spec api_endpoint() :: String.t()
  def api_endpoint, do: Application.get_env(:mailchimp, :api_endpoint, @default_api_endpoint)

  @doc """
  Return configured API Version

  ### Examples

      iex> Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      iex> Mailchimp.Config.shard!()
      "us12"
      iex> Application.delete_env(:mailchimp, :api_key)

  """
  @spec shard!() :: String.t() | no_return
  def shard! do
    api_key!()
    |> String.split("-", parts: 2)
    |> Enum.at(1)
  end

  @doc """
  Return configured API Version

  ### Examples

      iex> Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      iex> Application.delete_env(:mailchimp, :api_version)
      iex> Mailchimp.Config.root_endpoint!()
      "https://us12.api.mailchimp.com/3.0/"
      iex> Application.delete_env(:mailchimp, :api_key)

  """
  @spec root_endpoint!() :: String.t() | no_return
  def root_endpoint! do
    "https://#{shard!()}.#{api_endpoint()}/#{api_version()}/"
  end
end
