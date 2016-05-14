# Read about factories at https://github.com/thoughtbot/factory_girl
require 'ffaker'

FactoryGirl.define do
  factory :member do
    bcu_number "266762"
    first_name FFaker::Name.first_name
    last_name FFaker::Name.last_name
    middle_name FFaker::Name.first_name
    gender "m"
    birthdate "1978-05-11"
    # confirmed_at "2015-05-11"
    email FFaker::Internet.email

    factory :member_with_emails do
      after(:create) do |member|
        FactoryGirl.create( :email_address, emailable: member )
      end
    end

    factory :member_with_phone_numbers do
      after(:create) do |member|
        FactoryGirl.create( :phone_number, phoneable: member )
      end
    end

    factory :member_with_addresses do
      after(:create) do |member|
        FactoryGirl.create( :address, addressable: member, country: FactoryGirl.create( :country_with_states ) )
      end
    end

    factory :member_with_contact_info do
      after(:create) do |member|
        FactoryGirl.create( :email_address, emailable: member )
        FactoryGirl.create( :phone_number, phoneable: member )
        FactoryGirl.create( :address, addressable: member, country: FactoryGirl.create( :country_with_states ) )
      end
    end

    factory :member_with_qualifications do
      after( :create ) do |member|
        FactoryGirl.create( :qualification, member: member )
      end
    end
  end

  factory :member_with_centers, parent: :member_with_contact_info do
    after(:create) do |member|
      FactoryGirl.create( :center_with_contact_info, members: [member] )
    end
  end

end
