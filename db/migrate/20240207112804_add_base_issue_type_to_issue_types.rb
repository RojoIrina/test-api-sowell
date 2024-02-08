class AddBaseIssueTypeToIssueTypes < ActiveRecord::Migration[7.0]
  def change
    add_reference :issue_types, :base_issue_type, foreign_key: true
  end
end
