module MembersHelper
  def awards_by_type( awards, type )
    awards.select do |award|
      award.award_type == type
    end
  end
end
