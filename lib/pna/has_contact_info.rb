module Pna
  module HasContactInfo
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module InstanceMethods
      def email
        primary_email.nil? ? nil : primary_email.address
      end

      def email= email
        if self.new_record?
          @the_primary_email = self.email_addresses.new( :is_primary => true, address: email )
        else
          primary_email.update_attributes( :address => email )
        end
      end

      def primary_email
        if @the_primary_email
          @the_primary_email
        elsif self.new_record?
          if email_addresses.any?
            email_addresses.first.assign_attributes( is_primary: true )
          else
            nil
          end
        else
          @the_primary_email ||= self.email_addresses.where( :is_primary => true ).first # _or_initialize
        end
      end

      def public_email_addresses
        self.email_addresses.where( :public => true )
      end

      def phone_number
        primary_phone_number.nil? ? nil : primary_phone_number.number
      end

      def phone_number= number
        if self.new_record?
          @the_primary_phone = self.phone_numbers.new( :is_primary => true, :number => number )
        else
          phone_numbers.where( is_primary: true ).first_or_initialize.update_attributes( number: number )
        end
      end

      def primary_phone_number
        if @the_primary_phone
          @the_primary_phone
        elsif self.new_record?
          if phone_numbers.any?
            @the_primary_phone = phone_numbers.first.assign_attributes( is_primary: true )
          else
            nil
          end
        else
          @the_primary_phone ||= phone_numbers.where( is_primary: true ).first
        end
      end

      def public_phone_numbers
        self.phone_numbers.where( :public => true )
      end

      def mailing_address
        primary_address
      end

      def primary_address
        self.addresses.where( :is_primary => true ).first
      end

      def mailing_address= address
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
          :dependent => :delete_all #,
          #:validate => true

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
