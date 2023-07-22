require_relative "config"
require_relative "recipient_csv"
require_relative "label_document"

csv_filename = ARGV[0]

puts
puts "Reading CSV..."

recipients = RecipientCSV.from_csv(csv_filename)

puts
puts "Rendering PDF..."

label_document = LabelDocument.new(recipients)
pdf_file = csv_filename.gsub('recipients.csv', 'labels.pdf')
label_document.render_file(pdf_file)

puts "Done"
