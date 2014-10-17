###Problem

Find arbitrage loops in a currency exchange rate matrix.

###Background

In this hypothetical representation of cryptocurrency exchange, the rates between currencies are directional. Unlike the conventional currency market, the rate of exchange for US dollars differs when transferring to another currency versus when converting it back again. The imbalance created by this directionality creates arbitrage opportunities.

To recognize profitable arbitrage opportunities from a given exchange rate environment, we need to test all possible series of exchanges and see how much money we are left with at the end of the series. To determine what those pathways are, this R script finds the arbitrage loops and calculates the resulting gain or loss. 

![alt tag](https://raw.githubusercontent.com/ajkou/Bitcoin-Arbitrage/master/pathway_chart.png)

A basic characteristic of an arbitrage loop is that it starts from US dollars and ends by exchanging back to US dollars. 

The recursive function 'spit' seeks out all possible pathways from USD through other currencies. When the traversal encounters USD again, this serves as the terminating condition for the recursion, ending the path and identifying that path as an arbitrage loop. The resulting opportunity is then determined by taking the product of the exchange rates. This path searching algorithm probably performs at O(n^n).

###Solution

The following result was calculated from the exchange rate API (http://fx.priceonomics.com/v1/rates/), which produced a range [0.80, 1.20] with a maximum gain of 20%.


> sort(answer, decreasing=TRUE)

                    USD_EUR EUR_USD
                          1.2028279
                          
    USD_EUR EUR_BTC BTC_EUR EUR_USD
                          1.1944831
                          
            USD_EUR EUR_BTC BTC_USD
                          1.1681014
                          
    USD_EUR EUR_JPY JPY_EUR EUR_USD
                          1.1465524
                          
            USD_JPY JPY_EUR EUR_USD
                          1.0631893
                          
            USD_EUR EUR_JPY JPY_USD
                          1.0631738
                          
            USD_BTC BTC_EUR EUR_USD
                          1.0502753
                          
    USD_JPY JPY_EUR EUR_BTC BTC_USD
                          1.0324943
                          
    USD_EUR EUR_BTC BTC_JPY JPY_USD
                          1.0315540
                          
                    USD_BTC BTC_USD
                          1.0270786
                          
    USD_BTC BTC_EUR EUR_BTC BTC_USD
                          1.0199531
                          
                    USD_JPY JPY_USD
                          0.9858730
                          
    USD_EUR EUR_JPY JPY_BTC BTC_USD
                          0.9801219
                          
    USD_BTC BTC_JPY JPY_EUR EUR_USD
                          0.9781483
                          
    USD_JPY JPY_EUR EUR_JPY JPY_USD
                          0.9397480
                          
    USD_JPY JPY_BTC BTC_EUR EUR_USD
                          0.9293863
                          
    USD_BTC BTC_EUR EUR_JPY JPY_USD
                          0.9283333
                          
            USD_JPY JPY_BTC BTC_USD
                          0.9088596
                          
            USD_BTC BTC_JPY JPY_USD
                          0.9070163
                          
    USD_BTC BTC_JPY JPY_BTC BTC_USD
                          0.8361629
                          
    USD_JPY JPY_BTC BTC_JPY JPY_USD
                          0.8026167



