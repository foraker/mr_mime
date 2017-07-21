require 'spec_helper'
require 'models/mr_mime/store'
require 'models/mr_mime/adapters/base'
require 'models/mr_mime/impersonation_policy'
require 'models/mr_mime/impersonation'
require 'models/mr_mime/url_resolver'
require 'helpers/mr_mime/impersonation_helper'
require 'controllers/mr_mime/impersonation_behavior'
require 'controllers/mr_mime/application_controller'
require 'controllers/mr_mime/impersonations_controller'

module MrMime
  class DummyUser; end
  class DummyAdapter < Adapters::Base
    def set_current_user(user)
      context.session[:current_user_id] = user.id
    end
  end

  RSpec.describe ImpersonationsController, type: :controller do
    let(:main_app) { double(root_url: 'root_url', test_url: 'test') }
    let(:request) { double(referer: 'test_url') }
    let(:session) { { current_user_id: 1 } }
    let(:controller) { described_class.new }
    let(:users) { [double(id: 1), double(id: 2)] }

    before do
      stub_config
      stub_controller_messages
    end

    describe '#create' do
      context 'with a valid impersonation' do
        before do
          set_params impersonated_id: 2
        end

        it 'sets the current user' do
          controller.create
          expect(controller.current_user).to eq users.last
        end

        it 'sets the impersonator_id in the session' do
          controller.create
          expect(session['mr_mime.impersonator_id']).to eq 1
        end

        it 'sets the return_to url in the session' do
          controller.create
          expect(session['mr_mime.return_to']).to eq 'test_url'
        end

        it 'redirects to the root_url if no after_impersonation_url is set' do
          expect(controller).to receive(:redirect_to).with('root_url', anything)
          controller.create
        end

        it 'redirects to the correct after_impersonation_url if string' do
          MrMime::Config.after_impersonation_url = 'string_url'
          expect(controller).to receive(:redirect_to).with('string_url', anything)
          controller.create
        end

        it 'redirects to the correct after_impersonation_url if symbol' do
          MrMime::Config.after_impersonation_url = :test_url
          expect(controller).to receive(:redirect_to).with('test', anything)
          controller.create
        end

        it 'redirects to the correct after_impersonation_url if proc' do
          MrMime::Config.after_impersonation_url = Proc.new { |user| "users/#{user.id}" }
          expect(controller).to receive(:redirect_to).with('users/2', anything)
          controller.create
        end
      end

      context 'with an invalid impersonation' do
        before do
          set_params impersonated_id: nil
        end

        it 'does not change the current user' do
          controller.create
          expect(controller.current_user).to eq users.first
        end

        it 'does not set the impersonator_id' do
          controller.create
          expect(session).to_not have_key('mr_mime.impersonator_id')
        end

        it 'does not set the return_to url' do
          controller.create
          expect(session).to_not have_key('mr_mime.return_to')
        end

        it 'redirects back with error messages' do
          expect(controller).to receive(:redirect_to)
            .with(:back, {
              flash: {
                error: "Impersonated can't be blank"
              }
            })
          controller.create
        end
      end
    end

    describe '#destroy' do
      before { create_impersonation }

      it 'sets the current user' do
        controller.destroy
        expect(controller.current_user).to eq users.first
      end

      it 'clears the impersonator_id in the session' do
        controller.destroy
        expect(session['mr_mime.impersonator_id']).to be_blank
      end

      it 'clears the return_to url in the session' do
        controller.destroy
        expect(session['mr_mime.return_to']).to be_blank
      end

      it 'redirects to the return_to url' do
        expect(controller).to receive(:redirect_to).with('test_path', anything)
        controller.destroy
      end
    end

    def stub_config
      allow(DummyUser).to receive(:find_by) { |options| find_user(options) }
      allow(MrMime::Config).to receive_messages(
        user_class: DummyUser,
        adapter_class: DummyAdapter
      )
    end

    def stub_controller_messages
      allow(controller).to receive(:current_user) do
        find_user(id: session[:current_user_id])
      end

      allow(controller).to receive_messages(
        main_app: main_app,
        request: request,
        session: session,
        redirect_to: nil
      )
    end

    def create_impersonation
      set_params
      session.merge!(
        current_user_id: 2,
        'mr_mime.impersonator_id' => 1,
        'mr_mime.return_to' => 'test_path'
      )
    end

    def set_params(params = {})
      allow(controller).to receive_message_chain(:params, :fetch)
        .with(:impersonation, {})
        .and_return(params)
    end

    def find_user(id: id)
      users.detect{ |user| user.id == id }
    end
  end
end
