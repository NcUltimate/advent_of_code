# Order Analysis

One approach might be a “row re-scanning” strategy, which for a grid of width = height = `n` would take time `O(n * n)` per _row_. Overall that would result in `O(4 * n * n * n)` = `O(4n^3)` in the worst case, which occurs when a row is in ascending sorted order.

My solution looks in every direction at the same time to cut down on iterations. We’re down to O(n^3).

It determines scenery by storing “pointers” to the index of the most recent value larger than the value at each index. It follows those pointers as far to the beginning of the row as needed, and the current index minus wherever it lands is the scenery score in that direction at that index.

When a row is in descending sorted order, both solutions perform exactly the same (each tree can only see the tree next to it). These “best case” rows only require one scan, or `O(n)` time.

My solution makes a marked improvement on ascending sorted rows.  By preserving the most recent max pointer in a separate data structure, we can skip entire swaths of the row. This means scanning a row is now correlated to the _number of peaks in a row_. If that number is `k`, my solution runs in O(nk). When a row only has one peak, my algo therefore runs in O(n). However, the maximum number of peaks in a row occurs when a reverse-sorted and ascend-sorted array are evenly spliced to create (n/2) peaks. So in the worst case, my algo performs in O(n (n/2)) = O((n^2)/2).

This brings my overall worst case runtime to O((n^3)/2) and best case runtime to O(n^2).
