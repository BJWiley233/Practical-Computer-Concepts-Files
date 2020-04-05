#include <Rcpp.h>
#include <vector>

using namespace Rcpp;
using namespace std;


// [[Rcpp::export]]
NumericVector reg2bins(int beg, int end) {
  
  // Maximum range supported by specifications.
  int MAX_RNG = std::pow(2, 29) - 1;
  
  if (! (0 <= beg && beg <= end && end <= MAX_RNG)) stop("Invalid region %d, %d", beg, end);
  
  NumericVector bins = {1}; // initialize with bin 1 as no bin 0
  vector<vector<int>> bins_shifts;
  /**
   * Bin calculation constants & Shifts.  Only need extended bin if window past 512 mb as
   * indicated by from Jim Kent http://genomewiki.ucsc.edu/index.php/Bin_indexing_system
   */ 
  if (end < 512000000) {
    bins_shifts = {
      {1, 26},
      {9, 23},
      {73, 20},
      {585, 17}
    };
  }
  else {
    bins_shifts = {
      {1, 26},
      {9, 23},
      {73, 20},
      {585, 17},
      {4681, 14}
    };
  }
  
  for (int t = 0; t < bins_shifts.size(); ++t) {
    int start = bins_shifts.at(t).at(0);
    int shift = bins_shifts.at(t).at(1);
    int i, j;
    if (beg > 0)
      i = beg >> shift;
    else
      i = 0;
    if (end < MAX_RNG)
      j = end >> shift;
    else 
      j = MAX_RNG >> shift;
    
    for (int bin_id_offset = i; bin_id_offset < j+1; ++bin_id_offset) {
      bins.push_back(start + bin_id_offset);
    }
    
  }
  
  return bins;
}


/*** R

*/
