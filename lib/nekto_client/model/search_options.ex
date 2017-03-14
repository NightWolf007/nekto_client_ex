defmodule NektoClient.Model.SearchOptions do
  @moduledoc """
  Search options model
  """

  defstruct my_sex: nil, wish_sex: nil,
            my_age_from: nil, my_age_to: nil, wish_age: []

  @doc """
  Creates new SearchOptions model from hash

  ## Examples

      iex> hash = %{my_sex: "M", wish_sex: "F",
      ...>          my_age_from: 18, my_age_to: 21,
      ...>          wish_age: ["18t21"]}
      iex> NektoClient.Model.SearchOptions.new(hash)
      %NektoClient.Model.SearchOptions{my_sex: "M", wish_sex: "F",
                                       my_age_from: 18, my_age_to: 21,
                                       wish_age: ["18t21"]}
  """
  def new(hash) do
    %NektoClient.Model.SearchOptions{
      my_sex: Map.get(hash, :my_sex),
      wish_sex: Map.get(hash, :wish_sex),
      my_age_from: Map.get(hash, :my_age_from),
      my_age_to: Map.get(hash, :my_age_to),
      wish_age: Map.get(hash, :wish_age)
    }
  end

  @doc """
  Converts model to hash for sending

  ## Examples

      iex> search = %NektoClient.Model.SearchOptions{
      ...>                                    my_sex: "M", wish_sex: "F",
      ...>                                    my_age_from: 18, my_age_to: 21,
      ...>                                    wish_age: ["18t21"]}
      iex> NektoClient.Model.SearchOptions.serialize(search)
      %{my_sex: "M", wish_sex: "F", my_age_from: "18", my_age_to: "21",
        wish_age: ["18t21"]}
  """
  def serialize(search) do
    %{
      my_sex: to_string(search.my_sex),
      wish_sex: to_string(search.wish_sex),
      my_age_from: to_string(search.my_age_from),
      my_age_to: to_string(search.my_age_to),
      wish_age: search.wish_age
    }
  end
end
