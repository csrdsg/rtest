# Homework Assignment

In this homework, we will analyze London hotels and examine the relationship
between hotel price and distance from the city center.

1. Load the `hotels-europe_price.csv` dataset from OSF, then keep only the
   observations that originate from **weekdays in November 2017**.

2. Merge the dataset from the previous step with the
   `hotels-europe_features.csv` dataset, which is also available on OSF.

3. Keep only those hotels that are actually in **London** and for which we know
   their **price**, their **distance** from the city center, and their
   **star rating**. How many observations does the dataset contain now?

4. Calculate the **median** of the distance variable. Check the
   **average price** for hotels that are closer than the median distance and
   for those that are farther away. Based on this, what kind of sampling
   pattern do you observe between the two variables?

5. Create a **scatter plot** to visualize the relationship between price and
   distance. Don't forget to properly interpret the plot,
   including the appropriate **scaling of the y-axis**.

6. Calculate and interpret the **correlation coefficient** between price and distance.

> Later, we will discuss correlation and causality in detail, but for now, let's
> just think about it briefly! I claim that **hotels close to the center are more
> expensive because of their proximity, and hotels farther away are cheaper
> because they are far away.**

1. Can the results so far be used as an argument to support my claim?
   **Justify your answer!**

2. Calculate and interpret the correlation between **price and star rating**,
   as well as the correlation between **star rating and distance**.

3. Considering all three correlation coefficients together, would your answer
   to question 7 change, or do you stand by your position? **Justify your answer!**
