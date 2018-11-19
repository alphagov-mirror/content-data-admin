require 'rails_helper'

RSpec.describe "Chart", type: :view do
  let(:data) {
    {
      caption: "Unique page views",
      chart_label: "Page views chart",
      table_label: "Page views table",
      chart_id: 'pviews_jan_chart',
      table_id: 'pviews_jan_table',
      keys: %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec),
      rows: [
        {
          label: "2017",
          values: [5, 119, 74, 117, 50, 119, 61, 110, 12, 21, 121, 67]
        },
        {
          label: "2018",
          values: [3, 8, 37, 435, 78, 4, 9, 61, 110, 12, 21, 121]
        }
      ]
    }
  }

  it "does not render when no data is given" do
    assert_empty render_component({})
  end

  it "does not render if keys are missing" do
    data[:keys] = []
    assert_empty render_component(data)
  end

  it "does not render if row data is missing" do
    data[:rows] = []
    assert_empty render_component(data)
  end

  it "does not render if tab data is missing" do
    data[:chart_id] = false
    assert_empty render_component(data)
    data[:table_id] = false
    assert_empty render_component(data)
  end

  it "renders when given valid data" do
    render_component(data)
    assert_select '.app-c-chart', 1
  end

  it "renders the correct table data horizontally" do
    data[:table_direction] = 'horizontal'
    render_component(data)
    assert_select ".govuk-table__body .govuk-table__header:nth-child(1)", text: "2017"
    assert_select ".govuk-table__cell--numeric", 24
    assert_select ".govuk-table__header", 14
    assert_select "td:first", text: "5"
    assert_select "td:last", text: "121"
  end

  it "renders the correct table data vertically" do
    data[:table_direction] = 'vertical'
    render_component(data)
    assert_select ".govuk-table__body .govuk-table__header:nth-child(1)", text: "Jan"
    assert_select ".govuk-table__cell--numeric", 24
    assert_select ".govuk-table__header", 14
    assert_select "td:first", text: "5"
    assert_select "td:last", text: "121"
  end

  it "calls the chart library" do
    render_component(data)
    assert_select "script", text: /new Chartkick.LineChart/
  end

  def render_component(locals)
    render partial: "components/chart", locals: locals
  end
end
