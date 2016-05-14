class Center < ActiveRecord::Base
  #has_paper_trail

  has_contact_info

  has_and_belongs_to_many :members

  attr_accessible :name, :url, :email_addresses_attributes, :phone_numbers_attributes,
                  :addresses_attributes, :member_ids, :member_tokens, :email

  accepts_nested_attributes_for :email_addresses, :phone_numbers, :addresses

  validates :name, :url, :presence => true

  before_save :format_url

  def member_tokens
    member_ids.join(',')
  end

  def member_tokens=(tokens)
    self.members = Member.where( :id => tokens.first.gsub( /[^0-9,]/,'' ).split(',') )
  end

  def contact_link
    if url
      formated_url
    elsif email_addresses.any?
      "mailto:#{email_addresses.first.address}"
    else
      null
    end
  end

  def formated_url
    unless self.url[/http:\/\//] || self.url[/https:\/\//]
      "http://#{self.url}"
    else
      self.url
    end
  end

  private
  def format_url
    unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
      self.url = "http://#{self.url}"
    end
  end
end
