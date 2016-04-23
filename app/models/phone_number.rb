class PhoneNumber < ActiveRecord::Base
  #has_paper_trail

  belongs_to :phoneable, :polymorphic => true
  attr_accessible :ext, :label, :number, :phoneable_id, :phoneable_type, :public, :is_primary

  validates :number, :presence => true
  validate :phone_number_is_valid

  before_save :set_formated_number

  def to_s
    number
  end

  def phone_number_is_valid
    unless Phoner::Phone.valid?( number )
      errors.add( :number )
    end
  end

  def format_number
    phone = Phoner::Phone.parse number
    phone.format( number_country( number ) )
  end

  private
    def set_formated_number
      self.number = format_number
    end

    def number_country( number )
      country = Phoner::Phone.detect_country number
      if country.nil? || north_american_countries.include?( country.name )
        :us
      elsif european_countries.include? country.name
        :europe
      else
        :default
      end
    end

    def north_american_countries
      [
        'United States',
        'Canada'
      ]
    end

    def european_countries
      [
        'Austria',
        'Belgium',
        'Bulgaria',
        'Cyprus',
        'Czech Republic',
        'Denmark',
        'Estonia',
        'Finland',
        'France',
        'Germany',
        'Greece',
        'Hungary',
        'Ireland',
        'Italy',
        'Latvia',
        'Lithuania',
        'Luxembourg',
        'Malta',
        'Netherlands',
        'Poland',
        'Portugal',
        'Romania',
        'Slovakia',
        'Slovenia',
        'Spain',
        'Sweden',
        'United Kingdom'
      ]
    end
end
