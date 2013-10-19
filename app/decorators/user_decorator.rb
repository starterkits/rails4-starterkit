class UserDecorator < Draper::Decorator
  delegate_all
  def image
    h.image_tag object.image_url
  end
end