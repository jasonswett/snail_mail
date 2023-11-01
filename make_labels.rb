require_relative "label_document"
require_relative "recipient_csv"

csv_filename = ARGV[0]
label_document = LabelDocument.new(RecipientCSV.from_csv(csv_filename))

directory = File.dirname(csv_filename)
label_pdf_filename = File.join(directory, "labels.pdf")

label_document.render_file(label_pdf_filename)
puts label_pdf_filename
