module ActiveAdmin::ViewsHelper

  def address_inputs(f)
    f.input :address1
    f.input :address2
    f.input :city
    f.input :postal_code
    f.input :country_id, :as => :country, :priority_countries => PRIORITY_COUNTRIES, :input_html => { 'data-type' => 'country_select' }
    f.input :state, :as => :select, :collection => option_groups_from_collection_for_select( Country.order(:name), :states, :name, :id, :name ), :input_html => { 'data-type' => 'state_select' }
  end

  def phone_number_inputs(f)
    f.input :label, :hint => t('pna.hints.label')
    f.input :number
    f.input :ext
  end

  def email_address_inputs(f)
    f.input :label, :hint => t('pna.hints.label')
    f.input :address
  end

  def membership_inputs(f)
    f.input :organization, :as => :select, :collection => Membership::ORGANIZATION
    f.input :expiration_date, :as => :datepicker, :input_html => { 'data-years' => "c-1:c+5" }
    f.input :printed_on, :as => :datepicker, :input_html => { 'data-years' => "c-1:c+5" }
    f.input :sent
  end

  def invoice_inputs(f)
    f.inputs do
      f.input :member, :input_html => { "data-hook" => "choose" }
    end

    f.inputs do
      f.has_many :line_items do |l|
        l.input :description
        l.input :cost
        l.input :quantity
      end
    end

    f.inputs do
      f.has_many :payments do |p|
        p.input :source, :as => :select, :collection => Payment::SOURCE.inject({}) { |m,(k,v)| m.merge( { t("pna.payment_sources.#{k.to_s}") => v} ) }, :hint => t('pna.hints.payment.type')
        p.input :number, :hint => t('pna.hints.payment.number')
        p.input :exp_date, :hint => t('pna.hints.payment.exp_date'), :discard_day => true
        p.input :billing_name, :hint => t('pna.hints.payment.billing_name')
        p.input :amount, :hint => t('pna.hints.payment.amount')
      end
    end
  end

  def payment_inputs(f)
    f.input :source, :as => :select, :collection => Payment::SOURCE.inject({}) { |m,(k,v)| m.merge( { t("pna.payment_sources.#{k.to_s}") => v} ) }, :hint => t('pna.hints.payment.type')
    f.input :number, :hint => t('pna.hints.payment.number')
    f.input :exp_date, :hint => t('pna.hints.payment.exp_date'), :discard_day => true
    f.input :billing_name, :hint => t('pna.hints.payment.billing_name')
    f.input :amount, :hint => t('pna.hints.payment.amount')
  end

  def line_item_inputs(f)
    f.input :description
    f.input :cost
    f.input :quantity
  end

  def manage_txt(obj)
    "#{t('pna.manage')} #{obj}"
  end

end
