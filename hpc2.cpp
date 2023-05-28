#include <iostream>
#include <vector>
#include <chrono>
#include <omp.h>

// Sequential Bubble Sort
void sequentialBubbleSort(std::vector<int>& arr) {
    int n = arr.size();
    bool swapped;

    for (int i = 0; i < n - 1; ++i) {
        swapped = false;
        for (int j = 0; j < n - i - 1; ++j) {
            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
                swapped = true;
            }
        }

        if (!swapped) {
            // If no two elements were swapped, the array is already sorted
            break;
        }
    }
}

// Parallel Bubble Sort
void parallelBubbleSort(std::vector<int>& arr) {
    int n = arr.size();
    bool swapped;

    #pragma omp parallel
    {
        #pragma omp for
        for (int i = 0; i < n - 1; ++i) {
            swapped = false;
            for (int j = 0; j < n - i - 1; ++j) {
                if (arr[j] > arr[j + 1]) {
                    std::swap(arr[j], arr[j + 1]);
                    swapped = true;
                }
            }

            if (!swapped) {
                // If no two elements were swapped, the array is already sorted
                break;
            }
        }
    }
}

// Sequential Merge Sort
void sequentialMergeSort(std::vector<int>& arr, int start, int end) {
    if (start < end) {
        int mid = start + (end - start) / 2;

        sequentialMergeSort(arr, start, mid);
        sequentialMergeSort(arr, mid + 1, end);

        // Merge the two sorted subarrays
        std::vector<int> temp(end - start + 1);
        int i = start, j = mid + 1, k = 0;

        while (i <= mid && j <= end) {
            if (arr[i] <= arr[j]) {
                temp[k++] = arr[i++];
            } else {
                temp[k++] = arr[j++];
            }
        }

        while (i <= mid) {
            temp[k++] = arr[i++];
        }

        while (j <= end) {
            temp[k++] = arr[j++];
        }

        // Copy the merged elements back to the original array
        for (int m = 0; m < k; ++m) {
            arr[start + m] = temp[m];
        }
    }
}

// Parallel Merge Sort
void parallelMergeSort(std::vector<int>& arr, int start, int end) {
    if (start < end) {
        int mid = start + (end - start) / 2;

        #pragma omp parallel sections
        {
            #pragma omp section
            {
                parallelMergeSort(arr, start, mid);
            }

            #pragma omp section
            {
                parallelMergeSort(arr, mid + 1, end);
            }
        }

        // Merge the two sorted subarrays
        std::vector<int> temp(end - start + 1);
        int i = start, j = mid + 1, k = 0;

        while (i <= mid && j <= end) {
            if (arr[i] <= arr[j]) {
                temp[k++] = arr[i++];
            } else {
                temp[k++] = arr[j++];
            }
        }

        while (i <= mid) {
            temp[k++] = arr[i++];
        }

        while (j <= end) {
            temp[k++] = arr[j++];
        }

        // Copy the merged elements back to the original array
        for (int m = 0; m < k; ++m) {
            arr[start + m] = temp[m];
        }
    }
}

int main() {
    const int ARRAY_SIZE = 10000;
    std::vector<int> arr(ARRAY_SIZE);
    std::vector<int> arrCopy(ARRAY_SIZE);

    // Initialize the random seed
    std::srand(static_cast<unsigned>(std::time(nullptr)));

    // Initialize the arrays with random values
    for (int i = 0; i < ARRAY_SIZE; ++i) {
        int randomValue = std::rand() % ARRAY_SIZE + 1;
        arr[i] = randomValue;
        arrCopy[i] = randomValue;
    }

    // Sequential Bubble Sort
    auto startTime = std::chrono::steady_clock::now();
    sequentialBubbleSort(arr);
    auto endTime = std::chrono::steady_clock::now();
    auto sequentialTime = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();

    // Parallel Bubble Sort
    startTime = std::chrono::steady_clock::now();
    parallelBubbleSort(arrCopy);
    endTime = std::chrono::steady_clock::now();
    auto parallelTime = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();

    std::cout << "Sequential Bubble Sort execution time: " << sequentialTime << " milliseconds\n";
    std::cout << "Parallel Bubble Sort execution time: " << parallelTime << " milliseconds\n";

    // Reset the arrays
    arrCopy = arr;

    // Sequential Merge Sort
    startTime = std::chrono::steady_clock::now();
    sequentialMergeSort(arr, 0, arr.size() - 1);
    endTime = std::chrono::steady_clock::now();
    sequentialTime = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();

    // Parallel Merge Sort
    startTime = std::chrono::steady_clock::now();
    parallelMergeSort(arrCopy, 0, arrCopy.size() - 1);
    endTime = std::chrono::steady_clock::now();
    parallelTime = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();

    std::cout << "Sequential Merge Sort execution time: " << sequentialTime << " milliseconds\n";
    std::cout << "Parallel Merge Sort execution time: " << parallelTime << " milliseconds\n";

    return 0;
}