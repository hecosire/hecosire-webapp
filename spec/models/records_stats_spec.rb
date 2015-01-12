require 'spec_helper'

require 'models/records_stats'

describe RecordsStats do

  subject { RecordsStats.new(records) }

  describe 'dates_for_timechart' do

    let(:morning_record) { OpenStruct.new(created_at: DateTime.new(2001,2,3,4,5,6) ) }
    let(:evening_record) { OpenStruct.new(created_at: DateTime.new(2001,2,3,22,5,6) ) }
    let(:records) { [morning_record, evening_record] }

    it "maps recrods to dates_for_time chart format" do
      expect(subject.dates_for_timechart).to eq "'2001-02-03 04:05','2001-02-03 22:05'"
    end

  end

  describe 'states_for_timechart' do
    let(:healthy_record) { OpenStruct.new(health_state_id: 1 ) }
    let(:coming_down_record) { OpenStruct.new(health_state_id: 2 ) }
    let(:sick_record) { OpenStruct.new(health_state_id: 3 ) }
    let(:recovering_record) { OpenStruct.new(health_state_id: 4 ) }

    let(:records) { [healthy_record, coming_down_record, sick_record, recovering_record] }

    it "maps recrods to states_for_timechart format" do
      expect(subject.states_for_timechart).to eq "'4','2','1','3'"
    end
  end

end