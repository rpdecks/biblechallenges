class Parser
  def self.parse_query(query)
    regex = /^\s*([0-9]?\s*[a-zA-Z]+)\.?\s*([0-9]+)(?:\s*(?:-|..)[^0-9]*([0-9]+))?/
    match = query.match(regex)
    if match
      if match[3]
        chapters = (match[2]..match[3]).to_a
      else
        chapters = [ match[2] ]
      end
      [ match[1].gsub(/ /, ""), chapters ]
    else
      [nil, nil]
    end
  end
end