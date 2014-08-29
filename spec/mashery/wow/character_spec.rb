require 'spec_helper'

describe Mashery::WOW::Character do

  describe ".from_api" do
    it "is initialized"
  end

  describe ".find" do
    context "Specified character exists for the server" do
      it "returns an instance"
    end

    context "specified character does not exist on the server" do
      it "returns a nil"
    end
  end

end
