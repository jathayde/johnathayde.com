# == Schema Information
#
# Table name: articles
#
#  id                  :bigint           not null, primary key
#  author              :string
#  body                :text             not null
#  hidden_on_index     :boolean          default(FALSE)
#  img_source          :string
#  meta_description    :string(155)      not null
#  og_description      :string
#  og_image            :string
#  og_title            :string
#  page_title          :text             not null
#  published_at        :datetime
#  slug                :string
#  subtitle            :string
#  title               :string           not null
#  twitter_description :string
#  twitter_image       :string
#  twitter_title       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
