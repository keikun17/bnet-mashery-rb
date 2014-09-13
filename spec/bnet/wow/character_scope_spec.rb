require 'spec_helper'

shared_examples_for "memoized WoW character scope" do
  it 'memoizes character scope calls' do
    client = instance_double('Bnet::WOW')
    expect(Bnet::WOW).to receive(:new).and_return(client).exactly(:once)
    expect(client).to receive(:scoped).exactly(:once).and_return([1,2,3])
    subject.send(scope)
    subject.send(scope)
  end
end

describe Bnet::WOW::Character do

  context "Alexeistukov character" do
    subject(:character) { described_class.new(region: 'us', realm: 'Dragonmaw', name: 'Alexeistukov')}

    describe "#achievements", vcr: {cassette_name: 'WoW Alexeistukov achievements'} do
      it { expect(subject.achievements).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'achievements'}
      end
    end

    describe "#appearance", vcr: {cassette_name: 'WoW Alexeistukov Appearance'} do
      it { expect(subject.appearance).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'appearance'}
      end
    end

    describe "#feed", vcr: {cassette_name: 'WoW Alexeistukov Feed'} do
      it { expect(subject.feed).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'feed'}
      end
    end

    describe "#guild", vcr: {cassette_name: 'WoW Alexeistukov Guild'} do
      it { expect(subject.guild).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'guild'}
      end
    end

    describe "#hunter_pets", vcr: {cassette_name: 'WoW Alexeistukov Hunter Pets'} do
      it { expect(subject.hunter_pets).to be_nil }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'hunter_pets'}
      end
    end

    describe "#items", vcr: {cassette_name: 'WoW Alexeistukov Items'} do
      it { expect(subject.items).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'items'}
      end
    end

    describe "#mounts", vcr: {cassette_name: 'WoW Alexeistukov Mounts'} do
      it { expect(subject.mounts).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'mounts'}
      end
    end

    describe "#pets", vcr: {cassette_name: 'WoW Alexeistukov Pets'} do
      it { expect(subject.pets).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'pets'}
      end
    end

    describe "#pet_slots", vcr: {cassette_name: 'WoW Alexeistukov Pet Slots'} do
      it []
      it { expect(subject.pet_slots).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'pet_slots'}
      end
    end

    describe "#progression", vcr: {cassette_name: 'WoW Alexeistukov Progression'} do
      it { expect(subject.progression).to_not be_empty }
      it_behaves_like 'memoized WoW character scope' do
        let(:scope) {'progression'}
      end
    end
  end
end
