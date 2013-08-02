require 'rouge/plugins/redcarpet'
module Redcarpet
  module Render
    class RedmonsterTopicRender < HTML
      include Rouge::Plugins::Redcarpet
      def initialize(options={})
        super options.merge({:xhtml => true,
                            :filter_html => true,
                            :hard_wrap => true})
      end
    end
  end
end

class MarkdownConverter
  include Singleton

  def self.convert(text)
    self.instance.convert(text)
  end

  def convert(text)
    @converter.render(text)
  end

  private
    def initialize
      @converter = Redcarpet::Markdown.new(
        Redcarpet::Render::RedmonsterTopicRender.new,
        {
          :no_intra_emphasis => true,
          :fenced_code_blocks => true,
          :autolink => true,
          :strikethrough => true,
          :space_after_headers => true,
          :tables => true,
          :superscript => true,
        }
      )
    end
end
