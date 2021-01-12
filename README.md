# HelloFinance

Hello Finance is a financial API which consists on users who owns currency accounts given a valid [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217) code and can perform transfers between them.

When a transfer is made between distinct currency codes, the conversion is made through [Foreign exchange rates API](https://exchangeratesapi.io/), which returns a given exchange rate.

## External dependencies

- [Foreign exchange rates API](https://exchangeratesapi.io/)

## How to start

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Main releases

- StoneJS challenge (12/01/2020)