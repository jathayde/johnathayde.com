# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

# Markdown versions of blog posts (/blog/:slug.md)
Mime::Type.register "text/markdown", :md, %w[text/x-markdown]
