# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Monograph`
require 'rails_helper'
require 'hyrax/specs/shared_specs/indexers'

RSpec.describe MonographIndexer do
  subject(:indexer) { described_class.new(resource: resource) }
  let(:resource) { Monograph.new }
  let(:indexer_class) { described_class }

  it_behaves_like 'a Hyrax::Resource indexer'

  it 'indexes isbn' do
    resource.isbn = 'my-isbn'

    expect(indexer.to_solr[:isbn_sim]).to eq 'my-isbn'
  end
end
