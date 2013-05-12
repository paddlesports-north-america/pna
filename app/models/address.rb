class Address < ActiveRecord::Base
  has_paper_trail

  # handles country / state associations and validation
  has_region

  belongs_to :addressable, :polymorphic => true

  attr_accessible :address1, :address2, :addressable_id, :addressable_type, :city, :postal_code, :state_id, :country_id

  validates :address1, :city, :postal_code, :addressable, :country, :presence => true
end
