require 'spec_helper'

describe Bnet::Diablo3::Follower do

  describe('.from_api(follower_type, raw_response)') do
    subject {described_class.from_api(follower_type, raw_response)}
    let(:follower_type) {'templar'}
    let(:raw_response) do
      {
        'level' => 69,
        'stats' => {
          'magicFind' => 50,
          'experienceBonus' => 40,
          'goldFind' => 30
        },

        'skills' => [
          { 'skill' => {'name' => 'Falcon Punch'}},
          { 'skill' => {'name' => 'Surprise Abortion'}}
        ],

        'items' => {
          'head' => {'name' => 'Falcon Helmet', 'id' => 'Falcon_Helm'},
          'hands' => {'name' => 'Falcon Gloves', 'id' => 'Falcon_Gloves'}
        }
      }
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

    it "assign follower skills" do
      expect(subject.skills).to match([
        an_object_having_attributes(name: 'Falcon Punch'),
        an_object_having_attributes(name: 'Surprise Abortion')
      ])
    end

    it "assign follower items" do
      expect(subject.items).to match([
        an_object_having_attributes(location: 'head', name: 'Falcon Helmet', item_id: 'Falcon_Helm'),
        an_object_having_attributes(location: 'hands', name: 'Falcon Gloves', item_id: 'Falcon_Gloves')
      ])
    end
  end
end
