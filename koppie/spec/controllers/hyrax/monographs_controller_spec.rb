require "rails_helper"

RSpec.describe Hyrax::MonographsController do
  include Devise::Test::ControllerHelpers
  let(:user) { User.create(email: "moomin@example.com", password: 'password') }

  before { sign_in user }

  describe "#create" do
    let(:params) do
      {monograph: {title: ["Comet in Moominland"],
                   creator: ['Tove Jansson'],
                   record_info: "test controller record",
                   visibility: 'open'}}
    end

    it "mint an identifier" do
      post :create, params: params

      object = Hyrax.query_service.find_all_of_model(model: Monograph).first
      expect(object).to have_attributes(identifier: contain_exactly("my_id_scheme:#{object.id}"))

      # ensure the id is indexed
      solr_doc = Hyrax::SolrService.get("id:#{object.id}")['response']['docs'].first
      expect(solr_doc['identifier_ssim']).to contain_exactly("my_id_scheme:#{object.id}")
    end
  end
end
