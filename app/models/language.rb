# frozen_string_literal: true

class Language < ApplicationRecord
  CODE_LENGTH = (3..6).freeze
  FLAG_DIMENSIONS = [100, 500].freeze
  FLAG_THUMB_DIMENSIONS = [24, 120].freeze

  mount_uploader :flag, FlagUploader

  attr_accessor :flag_width, :flag_height

  # "New" is not :new because a method named "new" would break stuff. So, it is
  # "new_language" instead. Damn you Rails!
  enum status: %i[new_language progressing functional complete on_hold abandoned]

  belongs_to :user
  belongs_to :lang_type

  has_many :words

  validates :code,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: CODE_LENGTH,
            format: { with: /[A-Z0-9]/ }

  validates :name,       presence: true
  validates :nativename, presence: true
  validates :user,       presence: true

  validate :flag_dimensions, if: ->(l) { l.flag_width && l.flag_height }

  def self.languages_selecting(user, *selects)
    select(*selects).tap { |r| r.where(user: user) if user }
  end

  def to_param
    code
  end

  def flag?
    flag.file.present?
  end

  def flag_url
    flag? ? flag.url : 'flag_default.png'
  end

  def flag_thumb?
    flag.thumb.file.present?
  end

  def flag_thumb_url
    flag_thumb? ? flag.thumb.url : 'flag_default_thumb.png'
  end

  private

  def flag_dimensions
    errors.add :flag, :flag_dimensions, minw: FLAG_DIMENSIONS[0] if flag_width < FLAG_DIMENSIONS[0]
  end
end
