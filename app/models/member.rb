class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, # :validatable,
  #        :confirmable

  # include HasContactInfo

  #has_paper_trail

  has_contact_info
  # after_commit :save_primary_email, on: :create

  has_note

  before_save :update_membership_expires

  GENDER = { :male => 'm', :female => 'f', :other => 'o', :prefer_not_to_say => 'na' }

  scope :active, -> {
    joins( :memberships )
    .where('memberships.expiration_date = (SELECT MAX(memberships.expiration_date) FROM memberships WHERE memberships.member_id = members.id)')
    .where('memberships.expiration_date >= ?', Date.today)
    .group('members.id')
  }
  scope :expired, -> {
    joins( :memberships )
    .where('memberships.expiration_date = (SELECT MAX(memberships.expiration_date) FROM memberships WHERE memberships.member_id = members.id)')
    .where('memberships.expiration_date < ?', Date.today)
    .group('members.id')
  }
  scope :non_member, -> { includes(:memberships).where( memberships: { member_id: nil } ) }

  search_methods :has_qualifications_in
  scope :has_qualifications_in, lambda { |aids| has_qualifications( aids ) }


  has_and_belongs_to_many :centers

  has_many :qualifications, :dependent => :delete_all
  has_many :awards, through: :qualifications, order: [ :award_type, :name ]

  has_many :first_aid_certifications, :dependent => :delete_all
  has_many :course_participations, :class_name => 'CourseParticipant', :dependent => :delete_all
  has_many :courses, :through => :course_participations

  has_many :coached_courses, :class_name => 'CourseCoach'

  has_many :memberships, :dependent => :delete_all

  has_many :coaching_registrations
  has_many :leadership_registrations

  attr_accessible :bcu_number, :birthdate, :first_name, :gender, :last_name, :use_middle_name,
                  :middle_name, :addresses_attributes, :phone_numbers_attributes,
                  :email_addresses_attributes, :memberships_attributes, :show_on_coaches_page, :is_charter_member,
                  :mailing_address, :phone_number, :email, :password, :password_confirmation, :remember_me

  accepts_nested_attributes_for :addresses, :phone_numbers, :email_addresses, :memberships

  # before_validation :assign_primary_email
  #
  # def assign_primary_email
  #   # if we have an email address, butno primary, assign first as primary
  #   if email_addresses.any? && primary_email.nil?
  #     email_addresses.first.update_attributes( is_primary: true )
  #   end
  # end

  validates :first_name, :last_name, :presence => true
  validates :gender, :inclusion => { :in => Member::GENDER.values }
  # validates :primary_phone_number, :primary_address, :presence => true

  validate :birthdate_in_the_past

  # validate :primary_email_is_valid
  validate :primary_phone_number_is_valid
  validate :primary_address_is_valid

  # def primary_email_is_valid
  #   log_errors_from primary_email
  # end

  def primary_phone_number_is_valid
    log_errors_from primary_phone_number
  end

  def primary_address_is_valid
    log_errors_from primary_address
  end

  def log_errors_from obj
    unless obj.nil? || obj.valid?
      obj.errors.full_messages.each do |err|
        errors.add( :base, err )
      end
    end
  end

  def check_contact_info

  end

  #
  # def save_primary_email
  #   if primary_email.new_record? || primary_email.changed?
  #     primary_email.save
  #   end
  # end

  def self.has_qualifications( aids )
    uids = Qualification.where( :award_id => aids ).pluck( :member_id ).uniq
    Member.where( :id => uids )
  end

  #Override devise to work with EmailAddresses
  # def self.having_email email
  #   # Member.includes( :email_addresses ).where( 'members.primary_email_id = email_addresses.id AND email_addresses.address = ?', email ).first
  #   Member.includes( :email_addresses ).where( 'email_addresses.is_primary = ? AND email_addresses.address = ?', true, email )
  # end

  #Override devise to work with EmailAddresses
  # def self.find_first_by_auth_conditions warden_conditions
  #   conditions = warden_conditions.dup
  #   if email = conditions.delete(:email)
  #     having_email email
  #   else
  #     super(warden_conditions)
  #   end
  # end

  def name
    if use_middle_name
      "#{middle_name} #{last_name}"
    else
      "#{first_name} #{last_name}"
    end
  end

  # def email
  #   primary_email.address rescue nil
  # end
  #
  # def email= email
  #   self.primary_email = email_addresses.where( address: email ).first_or_initialize
  # end

  # def public_email_addresses
  #   email_addresses.select do |e|
  #     e.public?
  #   end
  # end

  def to_s
    "#{first_name} #{last_name}"
  end

  def pna_number
    self.id
  end

  def is_coach?
    self.awards.where( :award_type => [ Pna::ProgramType::COACHING, Pna::ProgramType::LEGACY ] ).any?
  end

  def membership
    # default scope on memberships is to order by expiration date
    memberships.last
  end

  def membership_status
    if memberships.empty? || memberships.last.expiration_date < Date.today
      :error
    elsif memberships.last.expiration_date < 30.days.from_now.to_date
      :warning
    else
      :ok
    end
  end

  protected
  def update_membership_expires
    unless memberships.empty?
      self.membership_expires = self.memberships.last.expiration_date
    end
  end

  private
  def birthdate_in_the_past
    unless birthdate.nil? || birthdate < Date.today
      errors.add( :birthdate )
    end
  end


end
