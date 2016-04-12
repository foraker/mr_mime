require 'spec_helper'
require 'helpers/mr_mime/impersonation_helper'
require 'controllers/mr_mime/impersonation_behavior'

module MrMime
  class DummyController < ActionController::Base
    include ImpersonationBehavior
  end

  RSpec.describe DummyController do
    let(:controller) { described_class.new }

    before { allow(controller).to receive(:session).and_return({}) }

    describe 'helpers' do
      it 'correctly includes all relevant helper methods' do
        expect(described_class.helpers.methods).to include(
          :current_impersonator,
          :impersonator?,
          :impersonator_id,
          :button_to_impersonate
        )
      end
    end

    describe '#current_impersonator' do
      it 'returns nil if there is no impersonator' do
        expect(controller.current_impersonator).to be_nil
      end

      context 'with impersonator' do
        let(:user_class) { double }

        before do
          allow(MrMime::Config).to receive(:user_class).and_return(user_class)
          set_impersonator 21
        end

        it 'returns nil if the impersonating user cannot be found' do
          find_user nil
          expect(controller.current_impersonator).to be_nil
        end

        it 'returns the impersonating user if present' do
          user = double
          find_user user
          expect(controller.current_impersonator).to eq user
        end
      end
    end

    describe '#impersonator?' do
      it 'returns true if an impersonator id exists' do
        set_impersonator 21
        expect(controller).to be_impersonator
      end

      it 'returns false otherwise' do
        expect(controller).not_to be_impersonator
      end
    end

    def set_impersonator(id)
      controller.session['mr_mime.impersonator_id'] = id
    end

    def find_user(return_value)
      allow(user_class).to receive(:find_by)
        .with(id: 21)
        .and_return(return_value)
    end
  end
end
