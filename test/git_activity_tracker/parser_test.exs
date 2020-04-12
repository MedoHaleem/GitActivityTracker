defmodule GitActivityTracker.ParserTest do
  use GitActivityTracker.DataCase, async: true
  use ExVCR.Mock

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    HTTPotion.start
    :ok
  end

  describe "Parser.parse_message_and_update_ready_release_ticket/1" do
    test "success sending the update" do
      use_cassette "success_updating_ticket" do
        owner = user_fixture()
        repo = repository_fixture()
        commit = commit_fixture(repo, owner)
        assert %{body: "", headers: headers, status_code: 200} = GitActivityTracker.Parser.parse_message_and_update_ready_release_ticket(commit)
      end
    end

    # Well we should have test for failed message but we don't have a real api to post to as webhook would always return success message
  end

  describe "Parser.parse_message_and_update_released_ticket/2" do
    test "success sending the update of released ticket" do
      use_cassette "success_updating_released_ticket" do
        owner = user_fixture()
        repo = repository_fixture()
        commit = commit_fixture(repo, owner)
        release = release_fixture(owner)
        assert %{body: "", headers: headers, status_code: 200} = GitActivityTracker.Parser.parse_message_and_update_released_ticket(release, commit)
      end
    end

  end
end
