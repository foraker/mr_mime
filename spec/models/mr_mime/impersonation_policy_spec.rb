require 'spec_helper'
require 'models/mr_mime/impersonation_policy'

module MrMime
  RSpec.describe ImpersonationPolicy, type: :model do
    describe '#allow?' do
      it 'returns true if no permission check is set' do
        expect(described_class.new(double, double)).to be_allowed
      end

      context 'with permission check' do
        before { MrMime::Config.user_permission_check = :check? }

        it 'allows admins to impersonate any user' do
          impersonator = double(check?: true)
          expect(described_class.new(impersonator, double)).to be_allowed
        end

        it 'does not allow a regular user to impersonate' do
          impersonator = double(check?: false)
          expect(described_class.new(impersonator, double)).not_to be_allowed
        end
      end
    end
  end
end
