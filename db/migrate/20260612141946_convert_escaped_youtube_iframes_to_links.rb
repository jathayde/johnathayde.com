# frozen_string_literal: true

# Iframe markup pasted into the Lexxy editor gets stored as escaped text
# (and the Action Text sanitizer would strip real iframes at render anyway).
# Replace any escaped YouTube iframe text in article bodies with a bare
# watch link — the blog renderer turns those into proper embeds.
class ConvertEscapedYoutubeIframesToLinks < ActiveRecord::Migration[8.1]
  def up
    ActionText::RichText.where(record_type: "Article", name: "body").find_each do |rich_text|
      html = rich_text.body.to_html
      next unless html.include?("&lt;iframe")

      updated = html.gsub(%r{&lt;iframe.*?&lt;/iframe&gt;}m) do |match|
        if match =~ %r{youtube(?:-nocookie)?\.com/embed/([\w-]+)}
          url = "https://www.youtube.com/watch?v=#{Regexp.last_match(1)}"
          %(<a href="#{url}">#{url}</a>)
        else
          match
        end
      end

      rich_text.update!(body: updated) if updated != html
    end
  end

  def down
    # Content repair — not reversible
  end
end
