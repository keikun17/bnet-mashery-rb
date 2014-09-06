require 'spec_helper'

describe Bnet::Diablo3::Follower do

  describe('.from_api(follower_type, raw_response)') do
    subject {described_class.from_api(follower_type, raw_response)}
    let(:follower_type) {'templar'}
    let(:raw_response) do
      {'level' => 69, 'stats' => {
        'magicFind' => 50,
        'experienceBonus' => 40,
        'goldFind' => 30,
      }}
    end

    it "should be initialized" do
      expect(subject).to be_an_instance_of(described_class)
      expect(subject).to have_attributes(
        {
          follower_type: 'templar',
          level: 69,
          magic_find: 50,
          experience_bonus: 40,
          gold_find: 30
        }
      )
    end
  end
end
