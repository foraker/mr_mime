require 'spec_helper'
require 'models/mr_mime/store'

module MrMime
  RSpec.describe Store do
    let(:store) { described_class.new({}) }

    before { stub_const("#{described_class}::PREFIX", 'prefix')}

    describe '#set_keys' do
      it 'correctly stores all prefixed key-value pairs' do
        store.set_keys(one: 1, two: 2)

        expect(store['prefix.one']).to eq 1
        expect(store['prefix.two']).to eq 2
      end
    end

    describe '#set' do
      it 'correctly stores a prefixed key-value pair' do
        store.set(:one, 1)
        expect(store['prefix.one']).to eq 1
      end
    end

    describe '#get' do
      it 'correctly retrieves a prefixed key-value pair' do
        store.set(:one, 1)
        expect(store.get(:one)).to eq 1
      end
    end
  end
end
