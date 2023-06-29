
# dividend_scraper

A short scraper to retrieve upcoming ASX stock dividends from Morningstar.

## Purpose

Morningstar provides a list of upcoming dividends via https://www.morningstar.com.au/Stocks/UpcomingDividends. This contains the expected `Ex Dividend Date`, `Dividend Pay Date` and `Amount`. Fortunately, the HTML table that contains the upcoming dividend data is not dynamic and can be easily scraped using the `rvest` R package.

## Usage

1. Run the `01_div_scraper.R` script to read in the DASS-42 csv data file.
2. This will retrieve the upcoming dividend details and also calculate a crude dividend yield for the stock.

## Considerations

* Note that the dividend yield is only a crude calculation as upcoming annual dividends are not available.


## Disclaimer

The analysis in this repository is for educational and informative purposes only. Do not use ths for commercial purposes and adhere to the [**Terms and conditions**](https://www.morningstar.com.au/About/Terms) provided by Morningstar.

## References

