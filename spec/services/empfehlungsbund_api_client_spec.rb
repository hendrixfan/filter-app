require 'spec_helper'

describe EmpfehlungsbundApiClient do
  specify 'Partner Events' do
    VCR.use_cassette 'eb_api_client/partner_events' do
      events = EmpfehlungsbundApiClient.partner_events
      expect(events.count).to be > 3
      event = events.first
      expect(event.url).to be_present
      expect(event.from).to be_present
    end
  end

  specify 'Community Events' do
    VCR.use_cassette 'eb_api_client/community_events', record: :new_episodes do
      events = EmpfehlungsbundApiClient.community_events
      expect(events.count).to be >= 1
      event = events.first
      expect(event.url).to be_present
      expect(event.from).to be_present
    end
  end
end
