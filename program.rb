require_relative "recipient_list"
require_relative "recipient_csv"
require_relative "label_document"

recipient_csv = RecipientCSV.new(recipients)
recipient_csv.write
exit

puts
puts "Rendering PDF..."

label_document = LabelDocument.new(recipients)
label_document.render_file("labels.pdf")

puts "Done"
