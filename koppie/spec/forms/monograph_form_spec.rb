# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource CollectionResource`
require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe MonographForm do
  let(:form) { described_class.new(resource) }
  let(:resource)   { Monograph.new }

  let(:valid_data) do
    {title: "Comet in Moominland",
     creator: "Tove Jansson",
     record_info: "test record",
     isbn: "978-3-16-148410-0"}
  end

  it "validates valid data" do
    expect(form.validate(valid_data)).to eq true
  end

  it "validates ISBN" do
    invalid_data = valid_data.merge(isbn: "not-an-isbn")

    expect(form.validate(invalid_data)).to be_falsey
  end
end
