# encoding: utf-8
class WelcomeController < ApplicationController
  def index
    @topics = Topic.home_topics(Siteconf::HOMEPAGE_TOPICS)
    @sticky_topics = Topic.sticky_topics
    @canonical_path = '/'
    @full_title = site_intro
    @seo_description = Siteconf.seo_description
    @current_nav_item = t(:homepage)

    respond_to do |format|
      format.html
    end
  end

  def popular
    @topics = Topic.popular(Siteconf::HOMEPAGE_TOPICS)
    @canonical_path = '/'
    @full_title = '热门话题'
    @seo_description = Siteconf.seo_description
    @current_nav_item = t(:popular)

    respond_to do |format|
      format.html 
    end
  end

  def goodbye
    @title = '登出'

    respond_to do |format|
      format.html
      format.mobile { add_breadcrumb @title }
    end
  end

  def captcha
    head :ok and return unless Siteconf.show_captcha?

    respond_to do |format|
      format.gif {
        session[:captcha] = Redmonster::Captcha.random_code
        send_data Redmonster::Captcha.image(session[:captcha]), :type => 'image/gif', :disposition => 'ineline'
      }
    end
  end

  def sitemap
    respond_to do |f|
      f.xml {
        max = 50000
        @lastmod = [
          Topic.order('updated_at DESC').first.try(:updated_at),
          Page.only_published.order('updated_at DESC').first.try(:updated_at),
          Comment.order('updated_at DESC').first.try(:updated_at),
        ].compact.max

        @pages = Page.only_published.all
        @topics = Topic.select('id, comments_count, updated_at').order('created_at DESC').limit(max - @pages.size - 1)
      }
    end
  end
end
