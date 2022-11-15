require 'spec_helper'

describe "Record model" do

  it "builds a display string for an untitled record using its parent resource and its date" do
    solr_result = ASUtils.json_parse(File.read(File.join(FIXTURES_DIR, 'solr_response.json')))
    record = Record.new(solr_result)
    expect(record.display_string).to eq "Resource with child inheriting title, bulk: 1900s"
  end

  it "determines whether a record should be considered to have an embed-able representative image" do
    archival_object = build(:json_archival_object, instances: [], resource: {"ref" => "/repositories/99/resources/99"})

    archival_object.representative_file_version = build(:json_file_version, use_statement: 'image-thumbnail')
    record = Record.new({ "json" => archival_object.to_json })
    expect(record.has_representative_image?).to be true

    archival_object.representative_file_version = build(:json_file_version, use_statement: 'image-service')
    record = Record.new({ "json" => archival_object.to_json })
    expect(record.has_representative_image?).to be true

    archival_object.representative_file_version = build(:json_file_version, use_statement: 'audio-service')
    record = Record.new({ "json" => archival_object.to_json })
    expect(record.has_representative_image?).to be false
  end
end
