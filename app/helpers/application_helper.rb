module ApplicationHelper
  include CommonHelper

  # Render a partial only one time.
  #
  # Useful for rendering partials that require JavaScript like Google Maps
  # where other views may have also included the partial.
  def render_once(view, *args, &block)
    @_render_once ||= {}
    if @_render_once[view]
      nil
    else
      @_render_once[view] = true
      render(view, *args, &block)
    end
  end
end
