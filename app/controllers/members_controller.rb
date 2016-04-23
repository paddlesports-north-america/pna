class MembersController < ApplicationController

  before_filter :authenticate_member!

  def dashboard
    @member = current_member
    @qualifications = Qualification.includes( :award ).where( :member_id => @member.id )

    @courses_taken = CourseParticipant.includes(
      :course => [ :program ]
    ).where( :member_id => @member.id )

    @courses_delivered = CourseCoach.includes(
      :course => [ :program ]
    ).where( :member_id => @member.id ).map { |cc| cc.course }
  end

  def info
    @member = current_member
  end

  def update
    @member = current_member

    if params[ :ref ] == 'contact'
      prime_for_address
    end
    
    if @member.update_attributes( params[ :member ] )
      flash[ :notice ] = 'Your settings have been saved'
    else
      flash[ :alert ] = 'There was a problem saving your settings'
    end

    render params[ :ref ].to_sym
  end

  def contact
    @member = current_member
    prime_for_address
  end

  def prime_for_address
    @states = State.all.inject({}) { |m,state|
      if m[ state.country_id ]
        m[ state.country_id ].push( [ state.name, state.id ] )
      else
        m[ state.country_id ] = [[ state.name, state.id ]]
      end

      m
    }
    pcids = PRIORITY_COUNTRIES.map { |pc| pc[ 1 ] }
    other_countries = Country.order( :name )
      .select { |c| !pcids.include? c[ 1 ] }
      .map { |c| [ c.name, c.id ] }

    @countries = [["North America", PRIORITY_COUNTRIES],
                  ["Other", other_countries ]]
  end
end
