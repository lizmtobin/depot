# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  # add hook method to be called in run time

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: /\.(gif|jpg|png)\Z/i,
    message: 'must be a URL for gif, jpg or png image'
  }

  private # not available as an action in controllers

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      # access to errors object, which validate method also stores error messages.
      # Here we associate the error with the base object
      throw :abort
      # abort destroy if condition unmet
    end
  end
end
