require 'spec_helper'

describe Mashery::API do
  let(:instance) { described_class.new(region: "eu") }

  describe "initialization" do
    it "can be initialized" do
      expect(instance).to be_a_kind_of(described_class)
      expect(instance.region).to eq("eu")
    end
  end

  describe "#url" do
    it "returns the base url by region" do
      expect(instance.url).to eq("https://eu.api.battle.net/")
    end
  end
end
