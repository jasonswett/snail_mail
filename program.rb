require_relative "config"
require_relative "recipient_list"
require_relative "recipient_csv"
require_relative "label_document"

puts
puts "Writing CSV..."

recipient_list = RecipientList.new
recipient_csv = RecipientCSV.new(recipient_list.items)
csv_filename = recipient_csv.write

puts
puts "Rendering PDF..."

label_document = LabelDocument.new(RecipientCSV.from_csv(csv_filename))
directory = File.dirname(csv_filename)
label_pdf_filename = File.join(directory, "labels.pdf")
label_document.render_file(label_pdf_filename)
puts label_pdf_filename

puts "Done"
