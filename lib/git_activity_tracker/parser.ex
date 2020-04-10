defmodule GitActivityTracker.Parser do

  # this is just simple implementation but this part of the app can  be an genserver
  #that in case if the failed response from ticket service we send try again in five minutes
  def parse(message) do
    [message, tickets] = String.split(message, "\n\n")
    IO.inspect message
    tickets = parse_tickets(tickets)
    IO.inspect tickets
  end

  def parse_tickets(tickets) do
    [head | _tail] = String.replace(tickets, "#", "") |> String.split("Ref: ", trim: true)
    tickets = String.split(head, ", ") |> Enum.map(fn x -> %{id: x} end)
    tickets
  end

  # def parse_tickets([], tickets), do: tickets

  def parse_message_and_update_ready_release_ticket(commit) do
    issues = parse(commit.message)
    body = %{
      query: ~S(state #{ready for release}),
      issues: issues,
      comment: "See SHA ##{commit.sha}"
    }

    HTTPotion.post Application.fetch_env!(:git_activity_tracker, :ticket_service_host), [body: Jason.encode!(body), headers: ["User-Agent": "Git Activity Tracker", "Content-Type": "application/json"]]

  end

  def parse_message_and_update_released_ticket(release, commit) do
    issues = parse(commit.message)
    body = %{
      query: ~S(state #{released}),
      issues: issues,
      comment: "Released in #{release.tag_name}"
    }

    HTTPotion.post Application.fetch_env!(:git_activity_tracker, :ticket_service_host), [body: Jason.encode!(body), headers: ["User-Agent": "Git Activity Tracker", "Content-Type": "application/json"]]

  end
end
