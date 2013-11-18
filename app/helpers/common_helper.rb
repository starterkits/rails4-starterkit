# Common helpers included in ApplicationController and ApplicationHelper
module CommonHelper
  include AuthenticationsHelper::Providers
  include DeviseRoutesHelper
  include GuidHelper
  include OauthHelper

end
