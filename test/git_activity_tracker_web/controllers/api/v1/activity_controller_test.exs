defmodule GitActivityTrackerWeb.Api.V1.ActivityControllerTest do
  use GitActivityTrackerWeb.ConnCase, async: true
  use ExVCR.Mock

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    HTTPotion.start
    :ok
  end

  @invalid_attrs %{
    "pull_request" => %{
      "commits" => nil
    },
    "repository" => %{"id" => nil, "name" => nil}
  }
  @create_attrs_pull %{
    "action" => "closed",
    "number" => 142,
    "pull_request" => %{
      "body" => "This is a pretty simple change that we need to pull into master.",
      "closed_at" => "2018-05-30T20:18:50Z",
      "commits" => [
        %{
          "author" => %{
            "email" => "ahmed@suitepad.de",
            "id" => 21431007,
            "name" => "ahmed"
          },
          "date" => "2018-05-27T16:00:49Z",
          "message" => "FIX: hide url not being passed to PDF URL\n\nRef: #sp-124",
          "sha" => "fbea31d5a04cd9e238fd45f3f27f314ebf707479"
        }
      ],
      "created_at" => "2018-05-30T20:18:30Z",
      "head" => %{"sha" => "34c5c7793cb3b279e22454cb6750c80560547b3a"},
      "id" => 191568743,
      "merge_commit_sha" => "414cb0069601a32b00bd122a2380cd283626a8e5",
      "number" => 1,
      "state" => "closed",
      "title" => "Update the README with deploy information",
      "updated_at" => "2018-05-30T20:18:50Z",
      "user" => %{
        "email" => "tarek@suitepad.de",
        "id" => 11010367,
        "name" => "tarek"
      }
    },
    "repository" => %{"id" => 135493233, "name" => "suitepad_api"}
  }

  @create_attrs_push %{
    "commits" => [
      %{
        "author" => %{
          "email" => "ahmed@suitepad.de",
          "id" => 21431007,
          "name" => "ahmed"
        },
        "date" => "2018-05-14T16:00:49Z",
        "message" => "FEAT: Support Android 8.1 devices \n\nRef: #sp-131",
        "sha" => "f66997d4630d353901a64f39df5f92asde4bc634"
      }
    ],
    "pushed_at" => "2018-05-29T20:18:44Z",
    "pusher" => %{
      "email" => "ahmed@suitepad.de",
      "id" => 21431007,
      "name" => "ahmed"
    },
    "repository" => %{"id" => 1354927974, "name" => "suite_apk"}
  }

  @create_attrs_release %{
    "action" => "released",
    "release" => %{
      "author" => %{
        "email" => "paul@suitepad.de",
        "id" => 21031067,
        "name" => "paul"
      },
      "commits" => [
        %{
          "author" => %{
            "email" => "paul@suitepad.de",
            "id" => 21031067,
            "name" => "paul"
          },
          "date" => "2018-05-24T16:00:49Z",
          "message" => "CHORE: Cleaner logging output\n\nRef: #happ-1224",
          "sha" => "78c4ef902de35c95a6b403c3f5c2e536cfbaab2e"
        },
        %{
          "author" => %{
            "email" => "mario@suitepad.de",
            "id" => 21001067,
            "name" => "mario"
          },
          "date" => "2018-05-21T09:50:49Z",
          "message" => "FIX: don't attempt invalid email notifications\n\nRef: #cro-12",
          "sha" => "37a8312ef07a9e729099a1eb8471dc37efa5ff56"
        }
      ],
      "id" => 11248810,
      "tag_name" => "1.0.1"
    },
    "released_at" => "2018-05-30T20:18:44Z",
    "repository" => %{"id" => 135493233, "name" => "suitepad_api"}
  }


  describe "create Activity" do
    test "renders list of commits when data is valid as pull payload", %{conn: conn} do
      conn = post(conn, Routes.api_v1_activity_path(conn, :create), @create_attrs_pull)
      assert [%{"data" => %{"id" => id}}] = json_response(conn, 201)["data"]
    end

    test "renders list of commits when data is valid as push payload", %{conn: conn} do
      use_cassette "success_updating_ticket" do
        conn = post(conn, Routes.api_v1_activity_path(conn, :create), @create_attrs_push)
        assert [%{"data" => %{"id" => id}}] = json_response(conn, 201)["data"]
      end
    end

    test "renders list of commits when data is valid as release payload", %{conn: conn} do
      use_cassette "success_updating_released_ticket" do
        conn = post(conn, Routes.api_v1_activity_path(conn, :create), @create_attrs_release)
        assert [%{"release" => release, "id" => id}, _] = json_response(conn, 201)["data"]
      end
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_activity_path(conn, :create), @invalid_attrs)
      assert %{"name" => ["can't be blank"], "uuid" => ["can't be blank"]}  = json_response(conn, 400)["errors"]
    end
  end
end
