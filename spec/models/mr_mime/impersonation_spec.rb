require 'spec_helper'
require 'models/mr_mime/store'
require 'models/mr_mime/impersonation_policy'
require 'models/mr_mime/impersonation'

module MrMime
  RSpec.describe Impersonation, type: :model do
    class UserClass; end
    class AdapterClass; end

    let(:context) { double }
    let(:adapter) { double(set_current_user: true) }
    let(:impersonator) { double(id: 3, email: 'impersonator@example.com') }
    let(:impersonated) { double(id: 8, email: 'impersonated@example.com') }
    let(:impersonation) do
      described_class.new(
        context: context,
        store: store,
        params: params
      )
    end

    before do
      stub_config
      stub_adapter
      stub_users
    end

    describe '#save' do
      let(:store) { {} }
      let(:params) do
        {
          impersonator_id: impersonator.id,
          impersonated_id: impersonated.id,
          referer: 'www.example.com/origin'
        }
      end

      context 'with a valid impersonation' do
        before { stub_policy(true) }

        it 'returns true' do
          expect(impersonation.save).to be_truthy
        end

        it 'sets the current user' do
          expect(adapter).to receive(:set_current_user).with(impersonated)
          impersonation.save
        end

        it 'sets the impersonator_id in the store' do
          impersonation.save
          expect_store_value :impersonator_id, impersonator.id
        end

        it 'sets the return_to in the store' do
          impersonation.save
          expect_store_value :return_to, 'www.example.com/origin'
        end
      end

      context 'with an invalid impersonation' do
        before { stub_policy(false) }

        it 'returns false' do
          expect(impersonation.save).to be_falsey
        end

        it 'does not set the current user' do
          expect(adapter).to_not receive(:set_current_user)
          impersonation.save
        end

        it 'does not set the impersonator_id' do
          impersonation.save
          expect_store_value :impersonator_id, nil
        end

        it 'does not set the return_to' do
          impersonation.save
          expect_store_value :return_to, nil
        end
      end
    end

    describe '#revert' do
      let(:store) do
        {
          'mr_mime.impersonator_id' => impersonator.id,
          'mr_mime.return_to' => 'www.example.com/origin'
        }
      end
      let(:params) do
        {
          impersonator_id: impersonator.id,
          referer: 'www.example.com/new'
        }
      end

      it 'reverts the current user' do
        expect(adapter).to receive(:set_current_user).with(impersonator)
        impersonation.revert
      end

      it 'clears the impersonator_id' do
        impersonation.revert
        expect_store_value :impersonator_id, nil
      end

      it 'clears the return_to' do
        impersonation.revert
        expect_store_value :return_to, nil
      end

      it 'retains the correct return_to' do
        impersonation.revert
        expect(impersonation.return_to).to eq 'www.example.com/origin'
      end
    end

    def expect_store_value(key, value)
      expect(store["mr_mime.#{key}"]).to eq value
    end

    def stub_config
      allow(MrMime::Config).to receive_messages(
        user_class: UserClass,
        adapter_class: AdapterClass
      )
    end

    def stub_adapter
      allow(AdapterClass).to receive(:new).with(context).and_return(adapter)
    end

    def stub_users
      allow(UserClass).to receive(:find_by) do |options|
        if    options[:id] == impersonator.id then impersonator
        elsif options[:id] == impersonated.id then impersonated
        else  nil
        end
      end
    end

    def stub_policy(allowed)
      allow(MrMime::ImpersonationPolicy).to receive(:allowed?)
        .with(impersonator, impersonated)
        .and_return(allowed)
    end
  end
end
