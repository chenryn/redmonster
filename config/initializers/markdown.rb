module Redcarpet
  module Render
    class RedmonsterTopicRender < HTML
      def initialize(options={})
        super options.merge({:xhtml => true,
                            :filter_html => true,
                            :hard_wrap => true})
      end

      def block_code(code, language)
        begin
          result = CodeRay.scan(code, language || :text).div(:tab_width => 2).sub("\n", '')
          i = result.rindex("\n")
          result = result[0..i-1] + result[i+1..-1]
          Redmonster::Base.protect_at_symbol result.gsub("\n", "<br/>")
        rescue Exception => e
          "~~~~#{Redmonster::Base.h language}#{Redmonster::Base.h code}"
        end
      end

      def block_quote(quote)
        %(<blockquote>#{quote}</blockquote>)
      end

      def block_html(raw_html)
        Redmonster::Base.h raw_html
      end

      def header(text, header_level)
        %(<h#{header_level}>#{Redmonster::Base.h text}</h#{header_level}>)
      end

      def hrule()
        %(<hr class="hrule"></hr>)
      end

      def list(contents, list_type)
        case list_type
        when :unordered
          %(<ul>#{contents}</ul>)
        when :ordered
          %(<ol>#{contents}</ol>)
        end
      end

      def list_item(text, list_type)
        %(<li>#{text}</li>)
      end

      def paragraph(text)
        %(<p>#{text}</p>)
      end

      def table(header, body)
        %(<table class="table table-bordered"><thead>#{header.gsub('td', 'th')}</thead><tbody>#{body}</tbody></table>)
      end

      def table_row(content)
        %(<tr>#{content}</tr>)
      end

      def table_cell(content, alignment)
        %(<td>#{content}</td>)
      end

      def autolink(link, link_type)
        case link_type
        when :url
          Redmonster::Base.smart_url(link)
        when :email
          Redmonster::Base.email_link(Redmonster::Base.protect_at_symbol(link))
        end
      end

      def codespan(code)
        %(<code>#{Redmonster::Base.protect_at_symbol(Redmonster::Base.h(code))}</code>)
      end

      def double_emphasis(text)
        %(<strong>#{text}</strong>)
      end

      def emphasis(text)
        "<em>#{text}</em>"
      end

      def image(link, title, alt_text)
        %(<img src="#{link}" alt="#{alt_text}" class="external" />)
      end

      def linebreak()
        "<br/>"
      end

      def link(link, title, content)
        content = link unless content.present?
        Redmonster::Base.external_link(content, link)
      end

      def raw_html(raw_html)
        Redmonster::Base.h raw_html
      end

      def triple_emphasis(text)
        %(<em>***#{text}***</em>)
      end

      def strikethrough(text)
        %(<del>#{text}</del>)
      end

      def superscript(text)
        %(<sup>#{text}</sup>)
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
