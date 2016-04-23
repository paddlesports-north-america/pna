# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160415144500) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "postal_code"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "public",           :default => false
  end

  add_index "addresses", ["addressable_type", "addressable_id"], :name => "index_addresses_on_addressable_type_and_addressable_id"
  add_index "addresses", ["country_id"], :name => "index_addresses_on_country_id"
  add_index "addresses", ["state_id"], :name => "index_addresses_on_state_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "awards", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "award_type"
    t.string   "na_number"
    t.string   "print_template"
    t.string   "ancestry"
  end

  add_index "awards", ["ancestry"], :name => "index_awards_on_ancestry"
  add_index "awards", ["name"], :name => "index_awards_on_name"

  create_table "centers", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "centers", ["name"], :name => "index_centers_on_name"

  create_table "centers_members", :id => false, :force => true do |t|
    t.integer "center_id"
    t.integer "member_id"
  end

  add_index "centers_members", ["center_id", "member_id"], :name => "index_centers_members_on_center_id_and_member_id"
  add_index "centers_members", ["member_id", "center_id"], :name => "index_centers_members_on_member_id_and_center_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "iso3"
    t.string   "iso"
    t.string   "iso_name"
    t.string   "numcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "course_coaches", :force => true do |t|
    t.integer  "member_id"
    t.integer  "course_id"
    t.boolean  "is_director", :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "course_coaches", ["course_id"], :name => "index_course_coaches_on_course_id"
  add_index "course_coaches", ["member_id"], :name => "index_course_coaches_on_member_id"

  create_table "course_participants", :force => true do |t|
    t.integer  "course_id"
    t.integer  "member_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "prerequisites_checked", :default => false
    t.string   "result"
  end

  add_index "course_participants", ["course_id"], :name => "index_course_participants_on_course_id"
  add_index "course_participants", ["member_id"], :name => "index_course_participants_on_member_id"

  create_table "courses", :force => true do |t|
    t.integer  "program_id"
    t.integer  "country_id"
    t.integer  "state_id"
    t.string   "venue"
    t.integer  "course_provider_id"
    t.integer  "center_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "show_on_calendar",   :default => true
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "course_number"
  end

  add_index "courses", ["center_id"], :name => "index_courses_on_center_id"
  add_index "courses", ["country_id"], :name => "index_courses_on_country_id"
  add_index "courses", ["course_number"], :name => "index_courses_on_course_number", :unique => true
  add_index "courses", ["course_provider_id"], :name => "index_courses_on_course_provider_id"
  add_index "courses", ["program_id"], :name => "index_courses_on_program_id"
  add_index "courses", ["state_id"], :name => "index_courses_on_state_id"

  create_table "email_addresses", :force => true do |t|
    t.string   "address"
    t.string   "label"
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "public",         :default => false
  end

  add_index "email_addresses", ["emailable_id", "emailable_type"], :name => "index_email_addresses_on_emailable_id_and_emailable_type"

  create_table "first_aid_certifications", :force => true do |t|
    t.string   "provider"
    t.date     "expiration_date"
    t.string   "certification_type"
    t.string   "certification_level"
    t.integer  "member_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "first_aid_certifications", ["member_id"], :name => "index_first_aid_certifications_on_member_id"

  create_table "members", :force => true do |t|
    t.string   "bcu_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "gender"
    t.date     "birthdate"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "provider_number"
    t.date     "membership_expires"
    t.boolean  "is_charter_member",    :default => false
    t.boolean  "show_on_coaches_page", :default => false
    t.boolean  "use_middle_name",      :default => false
  end

  add_index "members", ["bcu_number", "first_name", "last_name"], :name => "index_members_on_bcu_number_and_first_name_and_last_name"

  create_table "membership_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.date     "expiration_date"
    t.string   "organization"
    t.integer  "member_id"
    t.date     "printed_on"
    t.boolean  "sent",               :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "membership_type_id"
  end

  add_index "memberships", ["member_id"], :name => "index_memberships_on_member_id"

  create_table "notes", :force => true do |t|
    t.text     "body"
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.integer  "admin_user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "notes", ["admin_user_id"], :name => "index_notes_on_admin_user_id"
  add_index "notes", ["noteable_type", "noteable_id"], :name => "index_notes_on_noteable_type_and_noteable_id"

  create_table "phone_numbers", :force => true do |t|
    t.string   "label"
    t.string   "number"
    t.string   "ext"
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "public",         :default => false
  end

  add_index "phone_numbers", ["phoneable_id", "phoneable_type"], :name => "index_phone_numbers_on_phoneable_id_and_phoneable_type"

  create_table "products", :force => true do |t|
    t.string   "description"
    t.float    "amount"
    t.string   "category"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "award_id"
    t.string   "program_type"
  end

  create_table "qualifications", :force => true do |t|
    t.integer  "member_id"
    t.integer  "award_id"
    t.date     "printed_on"
    t.date     "awarded_on"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "verified"
  end

  add_index "qualifications", ["award_id"], :name => "index_qualifications_on_award_id"
  add_index "qualifications", ["course_id"], :name => "index_qualifications_on_course_id"
  add_index "qualifications", ["member_id"], :name => "index_qualifications_on_member_id"

  create_table "region_locations", :force => true do |t|
    t.integer  "region_id"
    t.integer  "location_id"
    t.string   "location_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "region_locations", ["region_id"], :name => "index_region_locations_on_region_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "rco_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "contact"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "member_id"
    t.string   "type"
    t.text     "prerequisites"
    t.integer  "assessor_id"
    t.integer  "trainer_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "award_id"
  end

  add_index "registrations", ["award_id"], :name => "index_registrations_on_award_id"
  add_index "registrations", ["member_id"], :name => "index_registrations_on_member_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "states", ["country_id"], :name => "index_states_on_country_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
