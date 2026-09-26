#include <Rcpp.h>
#include <algorithm>  // max
#include <climits>    // INT_MAX
#include <cmath>      // sqrt
#include <vector>

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

static inline int num2index(int x) { return (x - 3) / 2; }

static inline int index2num(int x) { return (x * 2) + 3; }

static inline int estimate_output_size(int min, int max) {
  return std::max(100, prime_count_impl(max, true) - prime_count_impl(min, false));
}

// [[Rcpp::export]]
std::vector<int> generate_primes_(int min, int max) {
  // NA means no upper limit, which for an int is INT_MAX. This is what
  // nth_prime_estimate_impl returns when its estimate does not fit in an int.
  if (max == NA_INTEGER)
    max = INT_MAX;

  if (max < 2 || min > max)
    return {};

  // NOTE: Equal to (max + 1) / 2 - 1 without the overflow at INT_MAX. For odd
  // max = 2k + 1 both are k; for even max = 2k both are k - 1.
  int len = (max - 1) / 2;
  std::vector<bool> a(len, true);
  for (int i = 3, stop = sqrt((double)max); i <= stop; i += 2) {
    if (!a[num2index(i)])
      continue;

    // Stop when the next multiple would pass max. Testing max - p rather than
    // p + inc keeps the last step from overflowing int when max is near
    // INT_MAX. p <= max holds throughout because i * i <= max.
    for (int p = i * i, inc = i * 2; ; p += inc) {
      a[num2index(p)] = false;
      if (max - p < inc)
        break;
    }
  }

  std::vector<int> out;
  out.reserve(estimate_output_size(min, max));

  if (min <= 2)
    out.push_back(2);
  // NOTE: Testing min > 2 first keeps (min - 2) from overflowing for min near
  // -INT_MAX; for min <= 2 the quotient is never positive anyway.
  for (int i = min > 2 ? (min - 2) / 2 : 0; i < len; i++)
    if (a[i])
      out.push_back(index2num(i));

  return out;
}
