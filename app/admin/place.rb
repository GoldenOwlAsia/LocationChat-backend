ActiveAdmin.register Place do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
  selectable_column
  column :id
  column :name
  column :longitude
  column :latitude
  column :address
  column :photo do |p|
    raw "<img src='#{p.photo_url}'/>"
  end
  actions
end

show title: :name do |emp|
  attributes_table do
    columns_to_exclude = ['photo_url' ]
    (Place.column_names - columns_to_exclude).each do |c|
      row c.to_sym
    end
    
    row 'Photo' do |e|
       raw "<img src='#{e.photo_url}'/>"
    end
  end
end


end
