class EmailAddress < ActiveRecord::Base
  #has_paper_trail

  belongs_to :emailable, :polymorphic => true
  attr_accessible :address, :emailable_id, :emailable_type, :label, :public, :is_primary

  validates :address, :email => true, :presence => true
  validates :address, :uniqueness => true, :if => :is_primary

  def to_s
    address
  end
end
