require 'spec_helper'
require 'models/mr_mime/url_resolver'

module MrMime
  RSpec.describe UrlResolver, type: :model do
    let(:main_app) { double(url_method: '/method_url', foo: '/proc_url/bar') }
    let(:model) { double(name: 'foo') }

    describe '.resolve' do
      it 'returns the correct url for a method proc' do
        expect_url '/proc_url/bar', from: url_method_proc
      end

      it 'returns the correct url for a string proc' do
        expect_url '/proc_url/foo', from: url_string_proc
      end

      it 'returns the correct url for a method name' do
        expect_url '/method_url', from: :url_method
      end

      it 'returns the correct url for a url string' do
        expect_url '/url_string', from: '/url_string'
      end

      it 'returns the default url if the given url does not resolve' do
        expect_url '/default_url', from: double
      end
    end

    def expect_url(url, options = {})
      expect(
        described_class.resolve(options[:from],
          context: double(main_app: main_app),
          args: model,
          default: '/default_url'
        )
      ).to eq url
    end

    def url_method_proc
      Proc.new { |model| model.name.to_sym }
    end

    def url_string_proc
      Proc.new { |model| "/proc_url/#{model.name}" }
    end
  end
end
