class Qualification < ActiveRecord::Base

  belongs_to :member
  belongs_to :award
  belongs_to :course
  attr_accessible :printed_on, :awarded_on, :award_id, :member_id, :course_id, :verified

  validates :member_id, :award_id, :presence => true

  delegate :award_type, to: :award
end
