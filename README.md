Imagine you generated a changelog based on commits and mixed up all the dates:

This tool allows you to sort all change blocks by date in descending order (from new to old).

You can copy the text directly into the UI, or you can open one or more files and click `Sort` to convert them.

You can also merge multiple logs from different files. Drag and drop all files into the UI or use the `Open` button.

Tip: you can use [QuickSwitch](https://github.com/JoyHak/QuickSwitch) for quick navigation in the file dialog. 

After sorting, you can copy the merged text or save it to a new file (the encoding will be `UTF-8`). 

You can also specify a regex for dates. It will be used to extract the date from each block. Subsequently, each date, hour, minute, and second (if time is found) will be used for sorting. For example, you can specify a regex for the format `00:00:01:0001` to sort blocks by milliseconds and seconds if they have the same hours and minutes (`00:00`).

Potentially, you can specify any regex to search for any string, number or letter. It affects sorting as follows:

-   Numbers sorted in descending order (from largest to smallest).
-   Strings sorted lexicographically (alphabetically, from `Z` to `A`). Sorting is case-sensitive by default ("apple" comes before "Apple").
-   Dates If stored as strings in `YYYY-MM-DD HH:MM` format or in ISO 8601 (e.g., "2025-09-16T11:40:54Z") format, sorted from left to right: by year, then by month, then by day, then by time (including any milliseconds or nanoseconds if any). It means that.
    -   If the format is different (e.g., `DD-MM-YYYY` or `MM/DD/YYYY`), lexicographical sorting will **not** match chronological order. In `MM/DD/YYYY` format, sorting compares characters from left to right: month, then day, then year. This causes months to be sorted before years, so after "01/01/2025" will be "01/01/2024" (all January dates from all years come before February, regardless of the year).
    -   Custom formats (e.g., `Sep 16, 2025`, `16 Sep 2025`) do not sort correctly because sorting is done by the first word: the month name or day, not by year or actual date, causing incorrect order. Month names (`Jan`, `Feb`, `Mar`, etc.) are sorted alphabetically. So after "Apr 16, 2025" will be "Feb 16, 2025".
    -   Only formats starting with the year (`YYYY-MM-DD`, `YYYY/MM/DD`, `YYYYMMDD`, ISO 8601) are reliably sortable as strings in chronological order. All other formats can produce incorrect or confusing sorting unless parsed and compared as actual date objects.
    -   The date and time separator (as well as their complete absence) doesn't matter. These dates are identical from a sorting perspective: 2025-09-16 18:00, 2025.09.16 18:00, 2025:09:16 18.00, 20250916 1800