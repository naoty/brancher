require "spec_helper"

describe Brancher::DatabaseTasks do
  describe ".rename_database" do
    before do
      allow(Brancher::DatabaseTasks).to receive(:current_configuration)
        .and_return(configuration)
    end

    let(:configuration) do
      {
        adapter: adapter,
        pool: 5,
        timeout: 5000,
        database: database_name
      }
    end

    let(:adapter) do
      "sqlite3"
    end

    let(:database_name) do
      "db/sample_app_development.sqlite3"
    end

    let(:branch) do
      "master"
    end

    let(:new_database_name) do
      "db/sample_app_development_#{branch}.sqlite3"
    end

    subject do
      Brancher::DatabaseTasks.rename_database(branch)
    end

    it { is_expected.to eq new_database_name }

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

      it { is_expected.to eq new_database_name }
    end
  end
end
