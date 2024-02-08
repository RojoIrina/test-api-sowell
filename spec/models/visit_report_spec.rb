require "rails_helper"

RSpec.describe VisitReport, type: :model do
  let(:visit_report) { create(:visit_report) }

  let(:other_company) { create(:company) }
  let(:other_checklist) { create(:checklist, company: other_company) }
  let(:other_visit_schedule) { create(:visit_schedule, checklist: other_checklist) }

  describe "#default visit_report" do
    it "is valid" do
      expect(visit_report).to be_valid
    end
  end

  describe "#visit_schedule" do
    it "is not empty" do
      expect do
        visit_report.visit_schedule_id = nil
        visit_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the company" do
      expect do
        visit_report.visit_schedule = other_visit_schedule
        visit_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#author" do
    it "is not empty" do
      expect do
        visit_report.author_id = nil
        visit_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#checkpoints" do
    # A first checkpoint is created by default
    let!(:first_checkpoint) { visit_report.visit_schedule.checklist.checkpoints.first }
    let!(:second_checkpoint) do
      create(:checkpoint, issue_type: first_checkpoint.issue_type, checklist: visit_report.visit_schedule.checklist)
    end
    let!(:third_checkpoint) do
      create(:checkpoint, issue_type: first_checkpoint.issue_type, checklist: visit_report.visit_schedule.checklist)
    end

    it "should all be checked" do
      expect do
        # Default factory does not include three checkpoints in visit_report
        visit_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        visit_report.checkpoints = [{ "id" => first_checkpoint.id, "status" => "ok" },
                                    { "id" => second_checkpoint.id, "status" => "ko" },
                                    { "id" => third_checkpoint.id, "status" => "missing" }]
        visit_report.save!
      end.not_to raise_error
    end

    it "should have correct statuses" do
      expect do
        visit_report.checkpoints.first["status"] = "fake"
        visit_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'validations' do
    it 'validates single location relation' do
      visit_schedule = build(:visit_schedule)
      expect(visit_schedule).to be_valid

      
      visit_schedule.place = create(:place, company: visit_schedule.checklist.company)
      visit_schedule.spot = create(:spot, place: visit_schedule.place)
      expect(visit_schedule).to_not be_valid
      expect(visit_schedule.errors[:base_location_type]).to include('must have only one location relation')
    end

    it 'validates depth_level correspondence' do
       base_location_type = create(:base_location_type, depth_level: :spot)
       visit_schedule = build(:visit_schedule, base_location_type: base_location_type)
       expect(visit_schedule).to be_valid
       visit_schedule.base_location_type = create(:base_location_type, depth_level: :residence)
       expect(visit_schedule).to_not be_valid
       expect(visit_schedule.errors[:base_location_type]).to include('depth_level must correspond to the specified location')
    end
  end


end
