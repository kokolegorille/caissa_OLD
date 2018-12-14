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

# GraphQL Sample queries

Without Relay...

{
  games(whitePlayer: "hou", zobristHash: "6549658867566488975") {
    id
    whitePlayer {
      lastName
      firstName
    }
    blackPlayer {
      lastName
      firstName
    }
    gameInfo
    event
    site
    round
    result
    year
    positions {
      fen
      zobristHash
    }
    insertedAt
    updatedAt
  }
}

With Relay...

{
  store {
    categories(first: 10) {
      pageInfo {
        hasNextPage
      }
      edges {
        cursor
        node {
          volume
          code
        }
      }
    }
  }
}

With params...

query Players($first: Int!) {
  store {
    players(first: $first) {
      edges {
        node {
          id
          lastName
          firstName
        }
      }
    }
  }
}

query Players($first: Int!) {
  store {
    players(first: $first) {
      edges {
        node {
          id
          lastName
          firstName
          insertedAt
          updatedAt
          games(first: 2, filter: {whitePlayer: "hou"}) {
            edges {
              node {
                whitePlayer {
                  lastName
                  firstName
                }
                blackPlayer {
                  lastName
                  firstName
                }
                event
                round
                site
                year
                result
                positions(first: 1) {
                  edges {
                    node {
                      fen
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

## Remove store

{
  games(first: 10) {
    edges {
      node {
        whitePlayer {
          lastName
          firstName
        }
        blackPlayer {
          lastName
          firstName
        }
        positions {
          moveIndex
          move 
          fen
          zobristHash
        }
      }
    }
  }
}

{
  game(id: 1) {
    whitePlayer { lastName }
    blackPlayer { lastName }
    positions {moveIndex move fen}
  }
}

With fragment

{
  game(id: 1) {
    whitePlayer {...PlayerFields}
    blackPlayer {...PlayerFields}
    positions {moveIndex move fen}
  }
}

fragment PlayerFields on Player {
  lastName
  firstName
}