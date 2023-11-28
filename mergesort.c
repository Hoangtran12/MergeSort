#include <stdio.h>

#define MAX_LIST_SIZE 32

int list[MAX_LIST_SIZE];

// Merge two sorted sublists into a larger sorted list
void merge(int start1, int end1, int start2, int end2) {
    int temp[end2 - start1 + 1];
    int i = start1, j = start2, k = 0;
    while (i <= end1 && j <= end2) {
        if (list[i] <= list[j]) {
            temp[k++] = list[i++];
        } else {
            temp[k++] = list[j++];
        }
    }
    while (i <= end1) {
        temp[k++] = list[i++];
    }
    while (j <= end2) {
        temp[k++] = list[j++];
    }
    for (i = start1; i <= end2; i++) {
        list[i] = temp[i - start1];
    }
}

int main() {
    printf("Enter the number of integers in the list (must be a power of 2 and no more than 32): ");
    int n;
    scanf("%d", &n);

    if (n <= 0 || n > MAX_LIST_SIZE || (n & (n - 1)) != 0) {
        printf("Error: List size must be a power of 2 and no more than 32\n");
        return 0;
    }

    printf("Enter %d integers:\n", n);
    for (int i = 0; i < n; i++) {
        scanf("%d", &list[i]);
    }

    // Sort the smallest possible sub-lists first, and then merge every two neighboring sub-lists
    int size = 1;
    while (size < n) {
        int start = 0;
        while (start < n) {
            int mid = start + size - 1;
            if (mid >= n) {
                break;
            }
            int end = (start + 2 * size - 1) < (n - 1) ? (start + 2 * size - 1) : (n - 1);
            merge(start, mid, mid + 1, end);
            start = start + 2 * size;
        }
        size = size * 2;
    }

    // Display the sorted list
    printf("Sorted list:\n");
    for (int i = 0; i < n; i++) {
        printf("%d ", list[i]);
    }
    printf("\n");

    return 0;
}
