require 'spec_helper'

describe Bnet::Starcraft2::Match do
  describe '.all(profile)', vcr: {cassette_name: 'SC2 Matches for Naniwa Profile found'} do
    subject{described_class.all(profile)}
    let(:profile) { Bnet::Starcraft2::Profile.new(profile_id: 2210662, name: 'NaNiwa', region: 'eu')}

    it "returns a collection of matches for a given profile"  do
      expect(subject).to include(
        an_object_having_attributes( map: "Deadwing LE", match_type: "SOLO", decision: "WIN", speed: "FASTER", date: 1410222237),
        an_object_having_attributes( map: "Deadwing LE", match_type: "SOLO", decision: "WIN", speed: "FASTER", date: 1410221657),
        an_object_having_attributes( map: "King Sejong Station LE", match_type: "SOLO", decision: "WIN", speed: "FASTER", date: 1410220846)
      )
    end

  end
end
