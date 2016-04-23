class AddPrimaryToContacts < ActiveRecord::Migration
  def change
    add_column :email_addresses, :is_primary, :bool, default: false
    add_column :phone_numbers, :is_primary, :bool, default: false
    add_column :addresses, :is_primary, :bool, default: false

    remove_column :members, :primary_email_id

    add_index :email_addresses, [ :is_primary, :emailable_type, :emailable_id ], name: 'uniq_primary_email'
    add_index :phone_numbers, [ :is_primary, :phoneable_type, :phoneable_id ], name: 'uniq_primary_phone'
    add_index :addresses, [ :is_primary, :addressable_type, :addressable_id ], name: 'uniq_primary_address'

    # clean orphans
    EmailAddress.where( :emailable_type => nil ).destroy_all
    PhoneNumber.where( :phoneable_type => nil ).destroy_all
    Address.where( :addressable_type => nil ).destroy_all

    # set primaries
    EmailAddress.uniq.pluck( :emailable_type ).each do |type|
      type.constantize.all.each do |i|
        if i.email_addresses.any?
          i.email_addresses.first.update_attributes( :is_primary => true )
        end
      end
    end

    PhoneNumber.uniq.pluck( :phoneable_type ).each do |type|
      type.constantize.all.each do |i|
        if i.phone_numbers.any?
          i.phone_numbers.first.update_attributes( :is_primary => true )
        end
      end
    end

    Address.uniq.pluck( :addressable_type ).each do |type|
      type.constantize.all.each do |i|
        if i.addresses.any?
          i.addresses.first.update_attributes( :is_primary => true )
        end
      end
    end
  end
end
