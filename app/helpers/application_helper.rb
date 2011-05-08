module ApplicationHelper
  def facebook_like(url)
    %{<iframe src="http://www.facebook.com/plugins/like.php?locale=es_ES&amp;href=#{CGI.escape(url)}&amp;send=false&amp;layout=button_count&amp;width=130&amp;show_faces=true&amp;action=recommend&amp;colorscheme=light&amp;font=verdana&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:130px; height:21px;" allowTransparency="true"></iframe>}.html_safe
  end

  def dt_dd(dt,dd)
    content_tag(:dt,dt)+content_tag(:dd,dd) if dd.present?
  end

  def app_sources_list(app)
    return nil if app.sources.empty?
    content_tag(:ul) do 
      app.sources.map do |source|
        content_tag(:li, link_to(source.title, source))
      end.join
    end
  end

  def down_arrow(hide = nil)
    %{<span class="pico"#{' style="display:none;"' if hide}>
    <span class="pico_outside">&nbsp;</span>
    <span class="pico_inside">&nbsp;</span>
    </span>}.html_safe
  end

  def thumbnails_for(app)
    content_tag(:ul) do 
      first = true
      app.screenshots.map do |screnshot|
        output = content_tag(:li, down_arrow(!first)+link_to(image_tag(screnshot.small),screnshot.big))
        first = false
        output
      end.join.html_safe
    end
  end
end
