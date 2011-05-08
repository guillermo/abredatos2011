module ApplicationHelper
  def facebook_like(url)
    width = 150;
    %{<iframe src="http://www.facebook.com/plugins/like.php?locale=es_ES&amp;href=#{CGI.escape(url)}&amp;send=false&amp;layout=button_count&amp;width=#{width}&amp;show_faces=true&amp;action=recommend&amp;colorscheme=light&amp;font=verdana&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:#{width}px; height:21px;" allowTransparency="true"></iframe>}.html_safe
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
      app.screenshots.ready.map do |screnshot|
        output = content_tag(:li, down_arrow(!first)+link_to(image_tag(screnshot.small),screnshot.big))
        first = false
        output
      end.join.html_safe
    end
  end
  
  def markdown(text)
    RDiscount.new(text).to_html.html_safe
  end
  
  def slides_for(collection, partial)
    slides_js
    %{<a class="backward">prev</a>
    <ul>#{ render :partial => partial, :collection => collection }</ul>
    <a class="forward">next</a>
    <div class="slidetabs">
    #{ '<a href="#"></a>'*collection.size}
    </div> <!-- the tabs -->
    }.html_safe
  end
  
  def slides_js
    
    js = <<-EOJS

    // What is $(document).ready ? See: http://flowplayer.org/tools/documentation/basics.html#document_ready
    $(function() {

    $(".slides .slidetabs").tabs("#head ul > li.slide", {

    	// enable "cross-fading" effect
    	effect: 'fade',
    	fadeOutSpeed: "fast",

    	// start from the beginning after the last tab
    	rotate: true

    // use the slideshow plugin. It accepts its own configuration
    }).slideshow();

    $(".slides .slidetabs").data("slideshow").play();
    });
    
    EOJS
    content_for :javascript, js.html_safe
    
  end
  
  def body_class
    "class=\"sources\"" if request.path =~ /^\/sources/
  end
end
