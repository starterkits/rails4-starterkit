Draper::CollectionDecorator.delegate :reorder, :page, :current_page, :total_pages, :limit_value, :total_count, :num_pages

ActiveAdmin.register User do
  decorate_with UserDecorator

  index do
    column :image
    column :first_name
    column :last_name
    column :email
    column :last_sign_in_at
    column :is_admin
    actions
  end
end
