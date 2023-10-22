# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Monograph`
require 'rails_helper'
require 'hyrax/specs/shared_specs/hydra_works'

RSpec.describe Monograph do
  subject(:work) { described_class.new }
  let(:resource) { work }

  it_behaves_like 'a Hyrax::Work'

  it "has a isbn field" do
    expect { work.isbn = '978-3-16-148410-0' }
      .to change { work.isbn }
      .to eq '978-3-16-148410-0'
  end
end
