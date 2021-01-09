defmodule HelloFinance.Currency do
  @required_keys [:code, :value]

  @enforce_keys @required_keys
  defstruct @required_keys

  @codes [
    :AED,
    :AFN,
    :ALL,
    :AMD,
    :ANG,
    :AOA,
    :ARS,
    :AUD,
    :AWG,
    :AZN,
    :BAM,
    :BBD,
    :BDT,
    :BGN,
    :BHD,
    :BIF,
    :BMD,
    :BND,
    :BOB,
    :BOV,
    :BRL,
    :BSD,
    :BTN,
    :BWP,
    :BYR,
    :BZD,
    :CAD,
    :CDF,
    :CHE,
    :CHF,
    :CHW,
    :CLF,
    :CLP,
    :CNY,
    :COP,
    :COU,
    :CRC,
    :CUC,
    :CUP,
    :CVE,
    :CZK,
    :DJF,
    :DKK,
    :DOP,
    :DZD,
    :ECS,
    :EGP,
    :ERN,
    :ETB,
    :EUR,
    :FJD,
    :FKP,
    :GBP,
    :GEL,
    :GHS,
    :GIP,
    :GMD,
    :GNF,
    :GTQ,
    :GYD,
    :HKD,
    :HNL,
    :HRK,
    :HTG,
    :HUF,
    :IDR,
    :ILS,
    :IMP,
    :INR,
    :IQD,
    :IRR,
    :ISK,
    :JMD,
    :JOD,
    :JPY,
    :KES,
    :KGS,
    :KHR,
    :KMF,
    :KPW,
    :KRW,
    :KWD,
    :KYD,
    :KZT,
    :LAK,
    :LBP,
    :LKR,
    :LRD,
    :LSL,
    :LTL,
    :LVL,
    :LYD,
    :MAD,
    :MDL,
    # :MGA,
    :MKD,
    :MMK,
    :MNT,
    :MOP,
    # :MRO,
    :MUR,
    :MVR,
    :MWK,
    :MXN,
    :MXV,
    :MYR,
    :MZN,
    :NAD,
    :NGN,
    :NIO,
    :NOK,
    :NPR,
    :NZD,
    :OMR,
    :PAB,
    :PEN,
    :PGK,
    :PHP,
    :PKR,
    :PLN,
    :PYG,
    :QAR,
    :RON,
    :RSD,
    :RUB,
    :RWF,
    :SAR,
    :SBD,
    :SCR,
    :SDG,
    :SEK,
    :SGD,
    :SHP,
    :SLL,
    :SOS,
    :SRD,
    :STN,
    :SVC,
    :SYP,
    :SZL,
    :THB,
    :TJS,
    :TMT,
    :TND,
    :TOP,
    :TRY,
    :TTD,
    :TWD,
    :TZS,
    :UAH,
    :UGX,
    :USD,
    :USN,
    :USS,
    # :UYI,
    :UYU,
    :UZS,
    :VES,
    :VND,
    :VUV,
    :WST,
    :XAF,
    # :XAG,
    # :XAU,
    # :XBA,
    # :XBB,
    # :XBC,
    # :XBD,
    :XCD,
    # :XDR,
    # :XFU,
    :XOF,
    # :XPD,
    :XPF,
    # :XPT,
    # :XTS,
    # :XXX,
    :YER,
    :ZAR,
    :ZMW,
    :ZWL
  ]

  def build(code, value) do
    %__MODULE__{
      code: code,
      value: value
    }
    |> validate_code()
    |> validate_value()
    |> apply_status()
  end

  defp validate_code(%{code: code} = currency) when is_atom(code), do: code_exists(currency, code)

  defp validate_code(%{code: code, value: value}) when is_binary(code) do
    atom_code = String.to_atom(code)

    currency = %{code: atom_code, value: value}
    code_exists(currency, atom_code)
  end

  defp code_exists(currency, code) do
    case Enum.member?(@codes, code) do
      true -> currency
      false -> {:error, message: "code not found"}
    end
  end

  defp validate_value({:error, _message} = error), do: error

  defp validate_value(%{value: value}) when not is_integer(value),
    do: {:error, message: "value should be an integer"}

  defp validate_value(%{value: value}) when value < 0,
    do: {:error, message: "value should be positive"}

  defp validate_value(currency), do: currency

  defp apply_status({:error, _message} = error), do: error
  defp apply_status(struct), do: {:ok, struct}
end
