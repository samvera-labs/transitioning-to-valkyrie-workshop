require 'rails_helper'

RSpec.describe "logging when events are published" do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }

  let(:work) do
    w = Monograph.new
    Hyrax.persister.save(resource: w)
  end

  it "logs when on Object deposited" do
    allow(Hyrax.logger).to receive(:info)
    expect(Hyrax.logger).to receive(:info).with("object.deposited: #{work.id}")

    Hyrax.publisher.publish('object.deposited', object: work, user: user)
  end

  it "logs when on Object metadata updated" do
    allow(Hyrax.logger).to receive(:info)
    expect(Hyrax.logger).to receive(:info).with("object.metadata.updated: #{work.id}")

    Hyrax.publisher.publish('object.metadata.updated', object: work, user: user)
  end
end
