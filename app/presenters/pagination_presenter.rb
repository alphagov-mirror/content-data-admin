class PaginationPresenter
  attr_reader :page, :total_pages, :total_results

  def initialize(page: 1, total_pages:, total_results:, per_page: 100)
    @page = page
    @total_pages = total_pages
    @total_results = total_results
    @per_page = per_page
  end

  def prev_link?
    page > 1
  end

  def prev_label
    "#{page - 1} of #{total_pages}"
  end

  def next_label
    "#{page + 1} of #{total_pages}"
  end

  def next_link?
    page < total_pages
  end

  def first_record
    return 1 if page == 1
    previous_record_count + 1
  end

  def last_record
    [@page * @per_page, @total_results].min
  end

  def paginate(items)
    Kaminari.paginate_array(items, total_count: @total_results)
      .page(@page).per(@per_page)
  end

private

  def previous_record_count
    (@page - 1) * @per_page
  end
end