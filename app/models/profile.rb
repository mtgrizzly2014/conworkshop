# frozen_string_literal: true
class Profile < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  belongs_to :user

  validates :country, inclusion: { in: ISO3166::Country.codes, allow_blank: true }
  validates :gender, inclusion: { in: CWS::Globals::GENDER_CODES, allow_blank: true }
  validates :about, length: { maximum: CWS::Globals::MAX_ABOUT_CHARS, allow_blank: true }

  def display_gender
    gender.present? ? CWS::Globals::GENDER_CODES[gender] : 'Not stated'
  end

  def display_country
    country.present? ? ISO3166::Country[country] : 'Nowhereland'
  end

  def avatar?
    avatar.file.present?
  end

  def avatar_url
    avatar? ? avatar.url : 'prof_default.png'
  end
end
