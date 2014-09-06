require 'spec_helper'

describe Bnet::Diablo3::Item do
  describe ".from_api(location, raw_response)" do
    subject { described_class.from_api(location, raw_response) }
    let(:location) {'head'}
    let(:raw_response) { {'name' => 'PooPoo Hat', 'id' => "Poopoo_69"} }

    it "should be initialized" do
      expect(subject).to be_a_kind_of(described_class)
      expect(subject).to have_attributes({
        name: 'PooPoo Hat',
        item_id: "Poopoo_69"
      })
    end

  end
end
