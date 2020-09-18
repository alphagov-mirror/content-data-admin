module TableDataSpecHelpers
  def extract_table_content(css_selector)
    Capybara.ignore_hidden_elements = false
    content = find(css_selector).all("tr").map do |el|
      el.all("th,td").map(&:text)
    end
    Capybara.ignore_hidden_elements = true

    content
  end
end
