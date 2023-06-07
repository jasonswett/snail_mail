require "csv"

class RecipientCSV
  def initialize(recipients)
    @recipients = recipients
  end

  def write
    CSV.open("recipients.csv", "wb") do |csv|
      csv << ["Name", "Address"]
      @recipients.each do |recipient|
        csv << [recipient[:name], recipient[:address]]
      end
    end
  end
end
