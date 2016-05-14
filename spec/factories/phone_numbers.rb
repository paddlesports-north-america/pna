# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_number do
    label "Work"
    number "360 555 1234"
    ext "543"
    is_primary false
    phoneable factory: :member
  end
end
