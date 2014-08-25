require 'spec_helper'

describe Mashery::Diablo3 do
  let(:instance) do
    described_class.new(region: "us", key: 'somekey', secret: 'somesecret')
  end

  describe "initialization" do
    it "can be initialized" do
      expect(instance).to be_a_kind_of(described_class)
      expect(instance.region).to eq("us")
      expect(instance.key).to eq("somekey")
      expect(instance.secret).to eq("somesecret")
      expect(instance.battletag).to eq("PlayerOne-1309")
    end
  end

  describe "url" do
    subject{ instance.url }
    it { is_expected.to eq("https://us.api.battle.net/d3/profile/PlayerOne-1309/") }
  end
end
