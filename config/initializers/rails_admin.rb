# RailsAdmin config file. Generated on October 19, 2013 23:33
# See github.com/sferik/rails_admin for more informations

if defined? RailsAdmin
  RailsAdmin.config do |config|

    ################  Global configuration  ################

    ## == Devise ==
    config.authenticate_with do
      warden.authenticate! scope: :user
    end
    config.current_user_method(&:current_user)

    ## == Cancan ==
    config.authorize_with :cancan

    ## == PaperTrail ==
    # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

    # Set the admin name here (optional second array element will appear in red). For example:
    #config.main_app_name = ['StarterKit', 'Admin']
    # or for a more dynamic name:
    config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

    # If you want to track changes on your models:
    # config.audit_with :history, 'User'

    # Display empty fields in show views:
    # config.compact_show_view = false

    # Number of default rows per-page:
    # config.default_items_per_page = 20

    # Exclude specific models (keep the others):
    # config.excluded_models = ['Authentication', 'User']

    # Include specific models (exclude the others):
    # config.included_models = ['Authentication', 'User']

    # Label methods for model instances:
    # config.label_methods << :description # Default is [:name, :title]


    ################  Model configuration  ################

    # Each model configuration can alternatively:
    #   - stay here in a `config.model 'ModelName' do ... end` block
    #   - go in the model definition file in a `rails_admin do ... end` block

    # This is your choice to make:
    #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
    #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


    # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
    # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:



    ###  Authentication  ###

    # config.model 'Authentication' do

    #   # You can copy this to a 'rails_admin do ... end' block inside your authentication.rb model definition

    #   # Found associations:

    #     configure :user, :belongs_to_association

    #   # Found columns:

    #     configure :id, :integer
    #     configure :user_id, :integer         # Hidden
    #     configure :provider, :string
    #     configure :proid, :string
    #     configure :token, :string
    #     configure :refresh_token, :string
    #     configure :secret, :string
    #     configure :expires_at, :datetime
    #     configure :username, :string
    #     configure :image_url, :string
    #     configure :created_at, :datetime
    #     configure :updated_at, :datetime

    #   # Cross-section configuration:

    #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
    #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
    #     # label_plural 'My models'      # Same, plural
    #     # weight 0                      # Navigation priority. Bigger is higher.
    #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
    #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

    #   # Section specific configuration:

    #     list do
    #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
    #       # items_per_page 100    # Override default_items_per_page
    #       # sort_by :id           # Sort column (default is primary key)
    #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
    #     end
    #     show do; end
    #     edit do; end
    #     export do; end
    #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
    #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
    #     # using `field` instead of `configure` will exclude all other fields and force the ordering
    # end


    ###  User  ###

    # config.model 'User' do

    #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

    #   # Found associations:

    #     configure :authentications, :has_many_association

    #   # Found columns:

    #     configure :id, :integer
    #     configure :first_name, :string
    #     configure :last_name, :string
    #     configure :image_url, :string
    #     configure :email, :string
    #     configure :password, :password         # Hidden
    #     configure :password_confirmation, :password         # Hidden
    #     configure :reset_password_token, :string         # Hidden
    #     configure :reset_password_sent_at, :datetime
    #     configure :remember_created_at, :datetime
    #     configure :sign_in_count, :integer
    #     configure :current_sign_in_at, :datetime
    #     configure :last_sign_in_at, :datetime
    #     configure :current_sign_in_ip, :string
    #     configure :last_sign_in_ip, :string
    #     configure :confirmation_token, :string
    #     configure :confirmed_at, :datetime
    #     configure :confirmation_sent_at, :datetime
    #     configure :unconfirmed_email, :string
    #     configure :failed_attempts, :integer
    #     configure :unlock_token, :string
    #     configure :locked_at, :datetime
    #     configure :created_at, :datetime
    #     configure :updated_at, :datetime
    #     configure :is_admin, :boolean

    #   # Cross-section configuration:

    #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
    #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
    #     # label_plural 'My models'      # Same, plural
    #     # weight 0                      # Navigation priority. Bigger is higher.
    #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
    #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

    #   # Section specific configuration:

    #     list do
    #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
    #       # items_per_page 100    # Override default_items_per_page
    #       # sort_by :id           # Sort column (default is primary key)
    #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
    #     end
    #     show do; end
    #     edit do; end
    #     export do; end
    #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
    #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
    #     # using `field` instead of `configure` will exclude all other fields and force the ordering
    # end

    # https://github.com/sferik/rails_admin/wiki/Actions
    config.actions do
      dashboard                     # mandatory
      index                         # mandatory
      new
      export
      bulk_delete
      show
      edit
      delete
      show_in_app

      ## With an audit adapter, you can add:
      # history_index
      # history_show
    end

  end
end
