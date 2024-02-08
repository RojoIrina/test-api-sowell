class Checkpoint < ApplicationRecord
  include CheckpointValidatable
  include CheckpointObserver

  belongs_to :checklist
  belongs_to :issue_type
  belongs_to :spot, optional: true
  belongs_to :residence, optional: true
end
