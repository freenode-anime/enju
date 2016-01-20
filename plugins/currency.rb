require 'money'
require 'money/bank/google_currency'
Money.use_i18n = false

class Currency
  include Cinch::Plugin

  match /^([\d\.,]{1,})\s([a-zA-Z]{3,4})\s(in)\s([a-zA-Z]{3,4})$/, :use_prefix => false

  def initialize(*args)
    super
    Money::Bank::GoogleCurrency.ttl_in_seconds = 86400
    Money.default_bank = Money::Bank::GoogleCurrency.new
  end

  def execute(m, amount, currency, type, to_currency)
    #begin
    begin
      money = Money.new(amount.to_i * 100, currency.upcase)
      currencied = money.exchange_to(to_currency.upcase.to_sym)
    rescue Money::Currency::UnknownCurrency
      m.reply "No currency with that ISO exist."
    rescue Money::Bank::UnknownRate
      m.reply "Google doesn't know any currency with that ISO."
    rescue Money::Bank::GoogleCurrencyFetchError
      m.reply "Issues fetching rates from the API."
    end

    if !currencied.nil?
      m.reply "#{amount} #{currency.upcase} is #{currencied.format(:symbol => nil, :thousands_separator => nil)} #{currencied.currency.iso_code}"
    end

  end

end
