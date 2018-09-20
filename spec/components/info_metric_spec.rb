require 'rails_helper'

RSpec.describe "Info Metric", type: :view do
  let(:data) {
    {
      name: "Unique pageviews",
      figure: "167,345",
      context: "This is in your top 10 items",
      trend_percentage: 0.5,
      period: "Apr 2018 to Mar 2018",
      about: "<p>This metric was extrapolated from measurement data.</p>"
    }
  }

  it "does not render when no data is given" do
    assert_empty render_component({})
  end

  it "does not render if name is not supplied" do
    data[:name] = false
    assert_empty render_component(data)
  end

  it "does not render if figure is not supplied" do
    data[:figure] = false
    assert_empty render_component(data)
  end


  it "renders correctly when given valid data" do
    render_component(data)
    assert_select ".app-c-info-metric"
    assert_select ".app-c-info-metric__heading", text: "Unique pageviews"
    assert_select ".app-c-info-metric__figure", text: "167,345"
    assert_select ".app-c-info-metric__context", text: "This is in your top 10 items"
    assert_select ".app-c-info-metric__trend", text: "+0.5%"
    assert_select ".app-c-info-metric__period", text: "Apr 2018 to Mar 2018"
    assert_select ".gem-c-details", 1
    assert_select ".app-c-info-metric__about .govuk-details__text", text: "<p>This metric was extrapolated from measurement data.</p>"
  end

  it "displays the correct trend direction when trend is supplied" do
    render_component(data)
    assert_select ".app-c-info-metric__trend--up .app-c-info-metric__trend-text", text: "Upward trend"
    data[:trend_percentage] = -2
    render_component(data)
    assert_select ".app-c-info-metric__trend--down .app-c-info-metric__trend-text", text: "Downward trend"
    data[:trend_percentage] = 0
    render_component(data)
    assert_select ".app-c-info-metric__trend--no-change .app-c-info-metric__trend-text", text: "No change"
  end

  it "does not render the detail link when no about data is supplied" do
    data[:about] = false
    render_component(data)
    assert_select ".gem-c-details", 0
  end

  def render_component(locals)
    render partial: "components/info-metric", locals: locals
  end
end