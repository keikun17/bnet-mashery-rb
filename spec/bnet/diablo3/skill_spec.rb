require 'spec_helper'

describe Bnet::Diablo3::Skill do

  describe ".from_api" do
    subject { described_class.from_api(api_args) }

    context "given the right parameters" do
      let(:api_args) do
        { "skill" => {
          "name" => "Magic Missile",
        },
        "rune" => {
          "name" => "Seeker",
        }
        }
      end

      it "can be initialized" do
        is_expected.to_not be_nil
      end

    end
  end

end
