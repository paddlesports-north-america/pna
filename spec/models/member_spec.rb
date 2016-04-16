require 'spec_helper'

describe Member do

  it "should have a valid factory" do
    FactoryGirl.build( :member ).should be_valid
  end

  it "should have a valid factory with fully populated contact info" do
    m = FactoryGirl.create( :member_with_contact_info )
    m.should be_valid
    m.email_addresses.should_not be_empty
    m.phone_numbers.should_not be_empty
    m.addresses.should_not be_empty
  end

  it "should have many addresses" do
    m = FactoryGirl.build( :member )
    m.should have_many( :addresses )
  end

  it "should have a valid factory with addresses" do
    m = FactoryGirl.create( :member_with_addresses )
    m.should be_valid
    m.addresses.should_not be_empty
  end

  it "should have many email addresses" do
    m = FactoryGirl.build( :member )
    m.should have_many( :email_addresses )
  end

  it "should have a valid factory with email addresses" do
    m = FactoryGirl.create( :member_with_emails )
    m.should be_valid
    m.email_addresses.should_not be_empty
  end

  it "should destroy phone numbers when it is destroyed" do
    m = FactoryGirl.create( :member_with_phone_numbers )
    pid = m.phone_numbers.last.id
    m.destroy
    PhoneNumber.exists?( pid ).should be_falsey
  end

  it "should have many phone numbers" do
    m = FactoryGirl.build( :member )
    m.should have_many( :phone_numbers )
  end

  it "should have a valid factory with phone numbers" do
    m = FactoryGirl.create( :member_with_phone_numbers )
    m.should be_valid
    m.phone_numbers.should_not be_empty
  end

  it "should destroy email addresses when it is destroyed" do
    m = FactoryGirl.create( :member_with_emails )
    eid = m.email_addresses.last.id
    m.destroy
    EmailAddress.exists?( eid ).should be_falsey
  end

  it "should have and belong to many centers" do
    m = FactoryGirl.build( :member )
    m.should have_and_belong_to_many( :centers )
  end

  it "should have a valid factory with centers" do
    m = FactoryGirl.create( :member_with_centers )
    m.should be_valid
    m.centers.should_not be_empty
  end

  it "should have many qualifications" do
    m = FactoryGirl.build( :member )
    m.should have_many( :qualifications )
  end

  it "should have a valid factory with qualifications" do
    m = FactoryGirl.create( :member_with_qualifications )
    m.should be_valid
    m.qualifications.should_not be_empty
  end

  it "should have many course participations" do
    m = FactoryGirl.build( :member )
    m.should have_many( :course_participations )
  end

  it "should have many courses through course participations" do
    m = FactoryGirl.build( :member )
    m.should have_many( :courses ).through( :course_participations )
  end

  it "should have many memberships" do
    m = FactoryGirl.build( :member )
    m.should have_many( :memberships )
  end

  describe '#valid?' do
    it "should validate gender against GENDER constant values" do
      m = FactoryGirl.build( :member, :gender => Member::GENDER[ :male ] )
      m.should be_valid
      m.gender = 'abcdefg'
      m.should_not be_valid
      m.errors.should include( :gender )
    end

    it "should require first_name" do
      m = FactoryGirl.build( :member, :first_name => nil )
      m.should_not be_valid
      m.errors.should include( :first_name )
    end

    it "should require last_name" do
      m = FactoryGirl.build( :member, :last_name => nil )
      m.should_not be_valid
      m.errors.should include( :last_name )
    end

    it "should not require middle name" do
      m = FactoryGirl.build( :member, :middle_name => nil )
      m.should be_valid
    end

    it "should require a birthdate in the past" do
      m = FactoryGirl.build( :member, :birthdate => 2.years.from_now.to_date )
      m.should_not be_valid
      m.errors.should include( :birthdate )
    end

  end

  describe '#membership' do
    it 'should return the most recent membership record by expiration date' do
      m = FactoryGirl.create( :member )

      latest_membership = FactoryGirl.create( :membership, member: m, expiration_date: 2.days.from_now )
      m.memberships << latest_membership

      m.memberships << FactoryGirl.create( :membership, member: m, expiration_date: 2.years.ago )
      m.memberships << FactoryGirl.create( :membership, member: m, expiration_date: 1.years.ago )
      m.memberships.length.should eq( 3 )

      tm = Member.find( 1 )
      tm.membership.expiration_date.should eq( latest_membership.expiration_date )
    end
  end
end
