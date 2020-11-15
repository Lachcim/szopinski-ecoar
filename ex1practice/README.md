# Practice tasks

1. Replace all digits in a string with their complement to 9 (0 becomes 9, 1 becomes 8, etc.)
2. Display the longest sequence of digits found in a string
3. Reverse the order of digits in a string
4. Scan the biggest unsigned decimal number found in a string and display its value using the `print_int` function
5. Display the number of decimal numbers (sequences of decimal digits) found in a string
6. Remove all digits from a string
7. Remove a sequence of characters specified by two positions from a string. Correctly handle out-of-range cases and reverse order of positions:
    * `abcdefgh 2 4` or `abcdefgh 4 2` produces `abfgh`
    * `abcdefgh 90 100` produces `abcdefgh`
    * `abcdefgh 10 5` produces `abcde`
8. Remove characters preceded by digits: `abc5f67gh` becomes `abc56h`
9. Change every third lowercase letter to uppercase: `ab1cde2f3gh4ij` becomes `ab1Cde2Fgh4Ij`
10. Remove all letters but the first from each sequence of uppercase letters: `ABCdefGHi` becomes `AdefGi`

The input string must be read from the console using the `read_string` function.
