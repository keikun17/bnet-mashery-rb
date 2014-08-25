require 'spec_helper'

describe Mashery::Diablo3::Career do

  describe ".find" do
    subject { described_class.find(battletag: 'PlayerOne-1306') }

    context "Playertag for the server exists" do
      it { pending }
      # it { is_expected.to_not be_nil }
    end

    context "Playertag for the server does not exist" do
      it { pending }
    end
  end

end
