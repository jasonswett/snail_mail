require "prawn"
require "prawn/table"

class LabelDocument < Prawn::Document
  COLUMN_COUNT = 3
  ROW_COUNT = 10
  FONT_SIZE = 8
  TOP_MARGIN = 40

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

    bounding_box([bounds.left, bounds.top - TOP_MARGIN], width: bounds.width, height: bounds.height - TOP_MARGIN) do
      table(
        rows,
        cell_style: {
          width: column_width,
          height: row_height,
          border_width: 0,
          padding: 0
        }
      )
    end
  end

  def column_width
    bounds.width / COLUMN_COUNT
  end

  def row_height
    (bounds.height - 10) / ROW_COUNT
  end
end
