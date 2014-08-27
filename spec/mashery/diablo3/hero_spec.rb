require 'spec_helper'

describe Mashery::Diablo3::Hero do

  describe ".find" do
    it "is instatiated from with an API call"
  end

  describe ".from_api" do

    context "Given the right parameters" do
      let(:api_args) do
        { "paragonLevel" => 0, "seasonal" => false, "name" => "PlayerOne",
          "id" => 1304986, "level" => 70, "hardcore" => false, "gender" => 0,
          "dead" => false, "class" => "wizard", "last-updated" => 1397322512
        }
      end
      subject { described_class.from_api(api_args) }

      it "can be initialized" do
        is_expected.to_not be_nil
      end

    end
  end

end
