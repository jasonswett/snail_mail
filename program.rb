require_relative "config"
require_relative "recipient_list"
require_relative "recipient_csv"

puts
puts "Writing CSV..."

recipient_list = RecipientList.new
recipient_csv = RecipientCSV.new(recipient_list.items)
csv_filename = recipient_csv.write

puts
puts "Rendering PDF..."

system("ruby make_labels.rb #{label_pdf_filename}")

puts "Done"
