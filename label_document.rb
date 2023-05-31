require "prawn"
require "prawn/table"

class LabelDocument < Prawn::Document
  COLUMN_COUNT = 3
  ROW_COUNT = 10
  FONT_SIZE = 8

  def initialize(recipients, options = {})
    super(options)
    Prawn::Fonts::AFM.hide_m17n_warning = true

    font_size(FONT_SIZE) do
      print_labels(recipients)
    end
  end

  def print_labels(recipients)
    recipients.each_slice(ROW_COUNT * COLUMN_COUNT).map do |recipients_for_page|
      print_page(recipients_for_page)
      start_new_page
    end
  end

  private

  def print_page(recipients)
    rows = recipients.each_slice(COLUMN_COUNT).map do |recipients_for_row|
      recipients_for_row.map { |recipient| "#{recipient[:name]}\n#{recipient[:address]}" }
    end

    table(rows, cell_style: { width: column_width })
  end

  def column_width
    bounds.width / COLUMN_COUNT
  end
end
