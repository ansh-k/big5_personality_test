class BigFiveResultsTextSerializer
  attr_reader :file_path, :name, :email

  def initialize(path)
    @file_path = path
    @name = 'Anshu Kumar'
  end

  def to_h
    doc = File.open(file_path).to_a
    result = {'NAME' => name}
    is_line_to_read = false
    start = true
    key = nil
    doc.each do |line|
      is_line_to_read = true if line.include? "Domain/Facet...... Score"
      is_line_to_read = false if line.include? "Your"
      key = nil if !is_line_to_read
      start = true if !key

      if is_line_to_read && line != ("\n") && !line.include?("Domain/Facet...... Score")
        if start
          key = line.slice(0..(line.index('.')-1))
          result[key] = {}
          result[key]['Facets'] ||= {}
          result[key]['Overall Score'] = line.scan(/\d+/)[0]
          start = false
        else
          result[key]['Facets'][line.slice(0..(line.index('.')-1))] = line.scan(/\d+/)[0]
        end
      end
    end
    result
  end
end

# puts BigFiveResultsTextSerializer.new("Personality-Test-Center.txt").to_h
