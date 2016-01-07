class Stocks

  def initialize(user, hash)

    @session ||= hash.nil? ? {} : hash
    @user_runs = _user_runs(user)
    @selected_run = _update_selected_run(@selected_run, @user_runs)

  end

  public

  def selected_run
    @selected_run
  end

  def user_runs
    @user_runs
  end

  def validate_stock(new_stock_symbol)
    url = "https://query.yahooapis.com/v1/public/yql?q="
    url += "select * from yahoo.finance.quote where symbol = '" + new_stock_symbol + "'"
    url += "&format=json&diagnostics=true&env=store://datatables.org/alltableswithkeys"

    url = URI.encode(url)
    URI.parse(url)

    resp = RestClient.get url, :content_type => :json, :accept => :json

    quote = JSON.parse(resp)['query']['results']['quote']
    valid = !quote['LastTradePriceOnly'].nil? && !quote['Volume'].nil? && !quote['YearHigh'].nil?
    valid
  end

  def enrich_stock_from_yahoo(stocks)
    unless stocks.size == 0
      stocks_results = get_stocks_from_basic(stocks)
      stocks_count = stocks_results['count']
      stocks_results = stocks_results['results']['quote']

      if stocks_count > 1
        stocks_results.each do |stock_json|
          enrich_stocks(stock_json, stocks)
        end
      else
        enrich_stocks(stocks_results, stocks)
      end
    end
  end


  def _update_selected_run(selected_run, runs)

    if @session['run_id'].to_s.empty? && selected_run.nil?
      selected_run = runs[0] unless runs.size == 0
    else
      selected_run = Run.find_by(id: @session['run_id'])
      selected_run = runs[0] if selected_run.nil? && runs.size > 0
    end
    @session['run_id'] = selected_run.nil? ? nil : selected_run.id
    selected_run
  end

  def _user_runs(current_user)
    current_user.groups.map { |group| group.runs }.flatten unless current_user.nil?
  end

  private
  def enrich_stocks(stock_json, stocks)
    stock_json = Hash[stock_json.map { |k, v| [k[0, 1].downcase + k[1..-1], v] }]
    stocks.each do |stock|
      if stock.symbol == stock_json['symbol']
        stock_json['symbol'] = stock.symbol
        stock.enrich_attrs(stock_json)
        run_id = stock.run_id
        run = Run.find_by(id: run_id)
        stock.run_name = run.name
      end
    end

  end

  def get_stocks_from_basic(basic_stocks)
    symbols = ''
    basic_stocks.each_with_index do |stock, index|
      symbols << ((index == basic_stocks.size - 1) ? "'" + stock.symbol + "'" : "'" + stock.symbol + "'" ',')
    end

    url = "https://query.yahooapis.com/v1/public/yql?q="
    url += "select * from yahoo.finance.quote where symbol in (#{symbols})"
    url += "&format=json&diagnostics=true&env=store://datatables.org/alltableswithkeys"

    url = URI.encode(url)
    URI.parse(url)

    resp = RestClient.get url, content_type: :json, accept: :json
    stocks_json = JSON.parse(resp)
    #stocks_count = stocks_json['query']['count']
    stocks_json['query'] #['results']['quote']
  end
end