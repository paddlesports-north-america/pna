ActiveAdmin.register Region do
  menu :parent => 'Settings'

  config.batch_actions = false

  form do |f|
    f.inputs do
      f.input :name
      f.input :rco_id, :as => :string,
        :label => 'Regional Representative',
        :input_html => member_autocomplete_options.merge( { :multiple => false } )

      f.input :contact, :label => 'Representative Contact'
    end
    f.actions
  end
end

ActiveAdmin.register RegionLocation do
  belongs_to :region
end
