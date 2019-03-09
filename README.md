# irr
This code computes NPV for multiple discount rates, then computes the Internal Rate of Return for an Investment.
Since there is no analytical solution for IRR, the discount rate is segmented along a vector in increments
of 0.00001%.

Then, once the biggest discount rate for which NPV>0 is found, and once the smallest discount rate for which NPV<0
is also found, the difference in the two values of NPV is used as a weighting scheme to interpolate between
the two corresponding discount rates. The result is the final IRR of the investment (source: Lee, Boehlje, Murray,
and Nelson. "Agricultural Finance", 8th Edition. 1888. Iowa State University Press.)

I am thinking a nice feature (for some future time) is to add animations or even just a line chart showing the NPV approach
and subsequently cross the breakeven point, with descriptive text in the body of the chart. Let me know your thoughts. 
