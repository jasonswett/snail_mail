require "csv"

class RecipientCSV
  def initialize(recipients)
    @recipients = recipients
  end

  def write
    filename = "recipients.csv"

    CSV.open(filename, "wb") do |csv|
      csv << ["Name", "Address"]
      @recipients.each do |recipient|
        csv << [recipient[:name], recipient[:address]]
      end
    end

    filename
  end

  def self.from_csv(filename)
    recipients = []
    CSV.foreach(filename, headers: true) do |row|
      recipients << {
        name: row["Name"],
        address: row["Address"]
      }
    end
    recipients
  end
end
