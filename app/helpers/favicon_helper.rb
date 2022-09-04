# frozen_string_literal: true

module FaviconHelper
  def apple_touch_icon_link_tag(options = {})
    size = options[:size] || '180'
    png_link_tag(
      rel: 'apple-touch-icon',
      size:,
      folder_name: 'favicons',
      file_prefix: 'apple-touch-icon'
    )
  end

  def favicon_png_link_tag(options = {})
    size = options[:size] || '32'
    file_prefix = options[:file_prefix] || 'favicon'
    png_link_tag(size:, file_prefix:)
  end

  private

  def png_link_tag(rel: 'icon', size: '32', folder_name: 'favicons', file_prefix: 'favicon')
    sizes = "#{size}x#{size}"
    filename = "#{folder_name}/#{file_prefix}-#{size}.png"
    favicon_link_tag(filename, rel:, sizes:, type: 'image/png')
  end
end
