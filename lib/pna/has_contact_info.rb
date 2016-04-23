module Pna
  module HasContactInfo
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module InstanceMethods
      def email
        primary_email.address
      end

      def email= email
        primary_email.update_attributes( :address => email )
      end

      def primary_email
        @primary_email ||= self.email_addresses.where( :is_primary => true ).first_or_initialize
      end

      def primary_email= email
          # @primary_email ||= self.email_addresses.where( :is_primary => true ).first_or_initialize
          # m.update_attributes( address: email )
          primary_email.address = email
      end

      def public_email_addresses
        self.email_addresses.where( :public => true )
      end

      def phone_number
        primary_phone_number
      end

      def phone_number= number
        primary_phone_number = number
      end

      def primary_phone_number
        @primary_phone ||= phone_numbers.where( is_primary: true ).first_or_initialize
      end

      def primary_phone_number= number
        primary_phone_number.number = number
      end

      def public_phone_numbers
        self.phone_numbers.where( :public => true )
      end

      # def address
      #   primary_address
      # end

      def primary_address
        self.addresses.where( :is_primary => true ).first
      end

      def primary_address= address
        addresses.where( is_primary: true ).first_or_initialize.update_attributes( address )
      end

      def public_addresses
        self.addresses.where( :public => true )
      end
    end

    module ClassMethods
      def has_contact_info
        has_many :phone_numbers,
          :as => :phoneable,
          :dependent => :delete_all,
          :validate => true

        has_many :email_addresses,
          :as => :emailable,
          :dependent => :delete_all,
          :validate => true

        has_many :addresses,
          :as => :addressable,
          :dependent => :delete_all,
          :validate => true

        search_methods :addresses_state_eq

        scope :addresses_state_eq, lambda { |state_id|
          self.joins(:addresses).where( 'addresses.state_id = ?', state_id )
        }

        search_methods :addresses_country_eq

        scope :addresses_country_eq, lambda { |country_id|
          self.joins(:addresses).where( 'addresses.country_id = ?', country_id )
        }

        include InstanceMethods
      end
    end
  end
end
