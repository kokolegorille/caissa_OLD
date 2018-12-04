# Caissa

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

This is an example of how a Phoenix application can depend on an ecto container.

You need to add dependency...

/mix.exs

{:chess_db, path: "../chess_db"}

Then, You need to duplicate the container conf in the main application...

/config/config.exs

config :caissa, ecto_repos: [ChessDb.Repo]
config :chess_db, :import, nbr_workers: 15

in dev.exs, prod.secret.exs, add db config.