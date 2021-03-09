# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/header"

describe LogStash::Filters::Header do

  describe "Test with a simple example" do
    let(:config) do <<-CONFIG
      filter {
        header {
          header_lines => 1
        }
      }
    CONFIG
    end

    sample [ "line 1", "line 2", "line 3" ] do
      expect(subject).to be_a(Array)
      insist { subject.size } == 2
      insist { subject[0].get("message") } == "line 1\nline 2"
      insist { subject[1].get("message") } == "line 1\nline 3"
    end
  end

  describe "No header should gave us raw text" do
    let(:config) do <<-CONFIG
      filter {
        header {
          header_lines => 0
        }
      }
    CONFIG
    end

    sample [ "line 1", "line 2", "line 3" ] do
      expect(subject).to be_a(Array)
      insist { subject.size } == 3
      insist { subject[0].get("message") } == "line 1"
      insist { subject[1].get("message") } == "line 2"
      insist { subject[2].get("message") } == "line 3"
    end
  end

  describe "Should work with a custom header" do
    let(:config) do <<-CONFIG
      filter {
        header {
          header_lines => 1
          header_delimiter => "-"
        }
      }
    CONFIG
    end

    sample [ "line 1", "line 2", "line 3" ] do
      expect(subject).to be_a(Array)
      insist { subject.size } == 2
      insist { subject[0].get("message") } == "line 1-line 2"
      insist { subject[1].get("message") } == "line 1-line 3"
    end
  end


  describe "Should work with a 3 header lines with custom delimiters" do
    let(:config) do <<-CONFIG
      filter {
        header {
          header_lines => 3
          header_delimiter => "-"
          header_global_delimiter => "->"
        }
      }
    CONFIG
    end

    sample [ "line 1", "line 2", "line 3", "line 4", "line 5"] do
      expect(subject).to be_a(Array)
      insist { subject.size } == 2
      insist { subject[0].get("message") } == "line 1-line 2-line 3->line 4"
      insist { subject[1].get("message") } == "line 1-line 2-line 3->line 5"
    end
  end

end
