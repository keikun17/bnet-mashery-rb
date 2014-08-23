require 'spec_helper'

describe Mashery::API do
  let(:instance) do
    described_class.new(region: "eu", key: 'somekey', secret: 'somesecret')
  end

  describe "initialization" do
    it "can be initialized" do
      expect(instance).to be_a_kind_of(described_class)
      expect(instance.region).to eq("eu")
      expect(instance.key).to eq("somekey")
      expect(instance.secret).to eq("somesecret")
    end
  end

  describe "#url" do
    it "returns the base url by region" do
      expect(instance.url).to eq("https://eu.api.battle.net/")
    end
  end
end
