require "prawn"
require "prawn/table"

class LabelDocument < Prawn::Document
  COLUMN_COUNT = 3
  ROW_COUNT = 10
  FONT_SIZE = 10 # Adjust the font size as desired

  def initialize(recipients, options = {})
    super(options)
    Prawn::Fonts::AFM.hide_m17n_warning = true
    create_labels(recipients)
  end

  def create_labels(recipients)
    font_size(FONT_SIZE) do
      rows = recipients.each_slice(COLUMN_COUNT).map do |group|
        group.map { |recipient| "#{recipient[:name]}\n#{recipient[:address]}" }
      end

      table(rows)
    end
  end
end
