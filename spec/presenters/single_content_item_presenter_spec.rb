RSpec.describe SingleContentItemPresenter do
  include GdsApi::TestHelpers::ContentDataApi

  let(:from) { '2018-01-01' }
  let(:to) { '2018-06-01' }
  let(:single_page_data) { default_single_page_payload('the/base/path', from, to) }
  let(:date_range) { build(:date_range, :last_30_days) }

  subject do
    SingleContentItemPresenter.new(single_page_data, date_range)
  end

  describe '#publishing_app' do
    it 'does not fail if no publishing app' do
      single_page_data[:metadata][:publishing_app] = nil

      expect(subject.publishing_app).to eq('Unknown')
    end

    it 'capitalizes the publishing_app if present' do
      expect(subject.publishing_app).to eq('Publisher')
    end
  end

  describe '#metadata' do
    it 'returns a hash with the metadata' do
      expect(subject.base_path).to eq('/the/base/path')
      expect(subject.published_at).to eq("17 July 2018")
      expect(subject.last_updated).to eq("17 July 2018")
      expect(subject.document_type).to eq("News story")
      expect(subject.publishing_organisation).to eq("The Ministry")
    end

    it 'returns the title' do
      expect(subject.title).to eq('Content Title')
    end
  end
end
