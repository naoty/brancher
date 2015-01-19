require "spec_helper"

describe Brancher::DatabaseRenameService do
  describe ".rename" do
    before do
      allow(Brancher::DatabaseRenameService).to receive(:current_branch)
        .and_return(branch)
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
          "database" => new_database_name
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
  end
end
