# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Monograph`
class MonographIndexer < Hyrax::ValkyrieWorkIndexer
  include Hyrax::Indexer(:basic_metadata)
  include Hyrax::Indexer(:monograph)

  # Uncomment this block if you want to add custom indexing behavior:
  def to_solr
    super.tap do |index_document|
      index_document[:identifier_ssim] = Array(resource.identifier).map(&:to_s)
    end
  end
end
