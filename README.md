EchoBotElixir
=============

## configure

cp config/dev.template.exs config/dev.exs

- change your `telegram_api_token`


## run

mix deps.get

mix compile

iex -S mix

> EchoBotElixir.start_link