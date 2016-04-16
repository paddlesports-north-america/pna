class MembersController < ApplicationController

  before_filter :authenticate_member!

  def dashboard
    @member = current_member
  end

end
