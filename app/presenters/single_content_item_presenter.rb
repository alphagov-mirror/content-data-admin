class SingleContentItemPresenter
  include MetricsFormatterHelper
  attr_reader :unique_pageviews, :pageviews, :unique_pageviews_series,
    :pageviews_series, :base_path, :title, :published_at, :last_updated,
    :publishing_organisation, :document_type, :number_of_internal_searches,
    :number_of_internal_searches_series, :satisfaction_score, :satisfaction_score_series,
    :date_range, :metadata

  def initialize(metrics, time_series, date_range)
    @date_range = date_range
    parse_metrics(metrics.with_indifferent_access)
    parse_time_series(time_series.with_indifferent_access)
  end

private

  attr_reader :from, :to

  def parse_metrics(metrics)
    @unique_pageviews = format_metric_value('unique_pageviews', metrics[:unique_pageviews])
    @pageviews = format_metric_value('pageviews', metrics[:pageviews])
    @number_of_internal_searches = format_metric_value('number_of_internal_searches', metrics[:number_of_internal_searches])
    @satisfaction_score = format_metric_value('satisfaction_score', metrics[:satisfaction_score])
    @title = metrics[:title]
    @metadata = {
      base_path: metrics[:base_path],
      document_type: metrics[:document_type].tr('_', ' ').capitalize,
      published_at: format_date(metrics[:first_published_at]),
      last_updated: format_date(metrics[:public_updated_at]),
      publishing_organisation: metrics[:primary_organisation_title],
    }
  end

  def parse_time_series(time_series)
    @unique_pageviews_series = get_chart_presenter(time_series, :unique_pageviews)
    @pageviews_series = get_chart_presenter(time_series, :pageviews)
    @number_of_internal_searches_series = get_chart_presenter(time_series, :number_of_internal_searches)
    @satisfaction_score_series = get_chart_presenter(time_series, :satisfaction_score)
  end

  def get_chart_presenter(time_series, metric)
    ChartPresenter.new(json: time_series, metric: metric, from: date_range.from, to: date_range.to)
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%-d %B %Y')
  end
end