require "spec_helper"

describe Brancher::DatabaseRenameService do
  describe ".rename" do
    before do
      allow(Brancher::DatabaseRenameService).to receive_messages(
        current_branch: branch,
        env: env
      )
    end

    let(:configurations) do
      {
        env => {
          "adapter" => adapter,
          "pool" => 5,
          "timeout" => 5000,
          "database" => database_name
        }
      }
    end

    let(:adapter) do
      "sqlite3"
    end

    let(:database_name) do
      "db/sample_app_development.sqlite3"
    end

    let(:env) do
      "development"
    end

    let(:branch) do
      "master"
    end

    let(:new_database_name) do
      "db/sample_app_development_#{branch}.sqlite3"
    end

    let(:new_configurations) do
      {
        env => {
          "adapter" => adapter,
          "pool" => 5,
          "timeout" => 5000,
          "database" => new_database_name,
          "original_database" => database_name
        }
      }
    end

    subject do
      Brancher::DatabaseRenameService.rename!(configurations)
    end

    it { is_expected.to eq new_configurations }

    context "when the adapter is mysql2" do
      let(:adapter) do
        "mysql2"
      end

      let(:database_name) do
        "sample_app_development"
      end

      let(:new_database_name) do
        "#{database_name}_#{branch}"
      end

      it { is_expected.to eq new_configurations }
    end

    context "when a database has already renamed" do
      let(:database_name) do
        "db/sample_app_development_#{branch}.sqlite3"
      end

      it { is_expected.to eq new_configurations }
    end

    context "when the database name is longer than max_database_name_length" do
      let(:adapter) do
        "mysql2"
      end

      let(:database_name) do
        "this_is_a_very_long_sample_app_development_database_name_that_exceeds_the_default_set_max_database_name_length"
      end

      let(:new_database_name) do
        "this_is_a_very_long_sample_app_developmen#{[Digest::MD5.digest("#{database_name}_#{branch}")].pack('m0').slice(0,22).gsub(/[^\w]/, '_').downcase}"
      end

      it { is_expected.to eq new_configurations }
    end

    context "when it connect another database" do
      let(:adapter) do
        "mysql2"
      end

      let(:database_name) do
        "sample_app_another_db"
      end

      let(:new_database_name) do
        "#{database_name}_#{branch}"
      end

      let(:env) do
        "another_db"
      end

      subject do
        Brancher::DatabaseRenameService.rename!(configurations, env)
      end

      it { is_expected.to eq new_configurations }
    end
  end
end
