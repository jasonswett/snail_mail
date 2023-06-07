require_relative "recipient_list"
require_relative "label_document"

puts
puts "Rendering PDF..."

label_document = LabelDocument.new(recipients)
label_document.render_file("labels.pdf")

puts "Done"
