class HomeController < ApplicationController

  # layout "front", :only => [ :index ]
  # layout "landing", :only => [ :landing ]

  def landing
  end

  def index
  end

  def about
    @regions = Region.includes( :rco, region_locations: [ :location ] ).order( :name ).all
  end

  def paddlers
  end

  def coaches
  end

  def membership
  end

  def contact
  end
  
  def candidates
    redirect_to :about
  end

end
