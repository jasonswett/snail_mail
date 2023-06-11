require_relative "recipient_csv"
require_relative "label_document"

puts
puts "Writing CSV..."

recipient_csv = RecipientCSV.new(recipients)
filename = recipient_csv.write

puts
puts "Rendering PDF..."

label_document = LabelDocument.new(RecipientCSV.from_csv(filename))
label_document.render_file("labels.pdf")

puts "Done"
