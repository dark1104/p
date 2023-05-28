//Implement Min, Max, Sum and Average operations using Parallel Reduction

#include <iostream>
#include <vector>
#include <numeric>

// Parallel Min
int parallelMin(const std::vector<int>& arr) {
    int minVal = arr[0];
    #pragma omp parallel for reduction(min:minVal)
    for (int i = 1; i < arr.size(); ++i) {
        if (arr[i] < minVal) {
            minVal = arr[i];
        }
    }
    return minVal;
}

// Parallel Max
int parallelMax(const std::vector<int>& arr) {
    int maxVal = arr[0];
    #pragma omp parallel for reduction(max:maxVal)
    for (int i = 1; i < arr.size(); ++i) {
        if (arr[i] > maxVal) {
            maxVal = arr[i];
        }
    }
    return maxVal;
}

// Parallel Sum
int parallelSum(const std::vector<int>& arr) {
    int sum = 0;
    #pragma omp parallel for reduction(+:sum)
    for (int i = 0; i < arr.size(); ++i) {
        sum += arr[i];
    }
    return sum;
}

// Parallel Average
double parallelAverage(const std::vector<int>& arr) {
    int sum = parallelSum(arr);
    double avg = static_cast<double>(sum) / arr.size();
    return avg;
}

int main() {
    std::vector<int> arr = {7, 2, 9, 1, 5, 6, 8, 3, 4};

    int minVal = parallelMin(arr);
    int maxVal = parallelMax(arr);
    int sum = parallelSum(arr);
    double avg = parallelAverage(arr);

    std::cout << "Min: " << minVal << std::endl;
    std::cout << "Max: " << maxVal << std::endl;
    std::cout << "Sum: " << sum << std::endl;
    std::cout << "Average: " << avg << std::endl;

    return 0;
}
