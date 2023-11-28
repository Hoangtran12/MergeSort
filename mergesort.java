import java.util.Scanner;

public class Mergesort {
   private static final int MAX_LIST_SIZE = 32;
   private static int[] list = new int[MAX_LIST_SIZE];

   // Merge two sorted sublists into a larger sorted list
   private static void merge(int start1, int end1, int start2, int end2) {
       int[] temp = new int[end2 - start1 + 1];
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

   // Main program to perform mergesort
   public static void main(String[] args) {
       Scanner scanner = new Scanner(System.in);
       System.out.print("Enter the number of integers in the list (must be a power of 2 and no more than 32): ");
       int n = scanner.nextInt();
       if (n <= 0 || n > MAX_LIST_SIZE || (n & (n - 1)) != 0) {
           System.out.println("Error: List size must must be a power of 2 and no more than 32");
           System.exit(0);
       }
       System.out.println("Enter " + n + " integers:");
       for (int i = 0; i < n; i++) {
           list[i] = scanner.nextInt();
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
               int end = Math.min(start + 2 * size - 1, n - 1);
               merge(start, mid, mid + 1, end);
               start = start + 2 * size;
           }
           size = size * 2;
       }

       // Display the sorted list
       System.out.println("Sorted list:");
       for (int i = 0; i < n; i++) {
           System.out.print(list[i] + " ");
       }
       System.out.println();
   }
}