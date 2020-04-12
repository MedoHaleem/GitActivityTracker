
# GitActivityTracker

  

To start your Phoenix server:

  

* Install dependencies with `mix deps.get`

* got to config/devs.exs and update the database username and password

* Create and migrate your database with `mix ecto.setup`

* Start Phoenix endpoint with `mix phx.server`

* Run tests by typing `mix test`

  

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

  

## Design Decisions
  

### Authentication:

I didn't implement an authentication system for the sake of simplicity and easier setup for the reviewer.

But I'm going to outline my thoughts regarding it:

While I don't know how the git hosting cloud service working but my experience integrating git hosting with CI like codeship only required using ssh keys but assuming that git hosting is another app written in elixir we can do the following in order of simplicity:

 - We can make our app to accept requests only coming from specific IP
   (Git Cloud Service), and this can be implemented on a system level
   using firewall or App level,
   
  - We can use a permanent access token to verify and authenticate the
   upcoming request
   
   - We can use Machine to Machine authentication and use third party
   service like Auth0, and assuming if the git service is also built on
   elixir we can use Genserver that fetch a new access token during init
   and get new token after expiration of the old token


### API to query and count commit activity by repo and committer:

I decided to tackle this issue and I know it was meant for future discussion but I learned something new from it.

for starter Ecto doesn't offer "polymorphic associations" so traditional way using ActiveRecord (In Rails) or Sequelize (NodeJs).

so I had to improvise by using abstract schema

```
  def list_schema_commit_counts(schema) do
    from(s in schema,
      join: c in assoc(s, :commits),
      join: u in assoc(c, :user),
      group_by: [s.id, u.id],
      select: %{schema: s, user: u, commit_count: count(c.id)}
    )
    |> Repo.all()
  end
```

and use functions to pass the schema I want then group by user_id
```
  def list_repo_commit_counts_by_user() do
    list_schema_commit_counts(Repository)
    |> Enum.group_by(fn %{user: user} -> user.id end)
  end

  def list_releases_commit_counts_by_user() do
    list_schema_commit_counts(Release)
    |> Enum.group_by(fn %{user: user} -> user.id end)
  end
```

another way of doing it is to have many-to-many joins `ReleaseCommits` / `UserCommits` / `RepoCommits` tables which joined their content types to `Commits`.