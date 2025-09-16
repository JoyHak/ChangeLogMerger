<img width="1728" height="914" alt="logo" src="https://github.com/user-attachments/assets/6f221547-42b9-4917-8ea6-8f66c4ef3594" />

Imagine you generated a changelog based on commits and mixed up all the dates:
```js
v27.10.0800 - 2025-09-09 18:00
    - fix 1
    - fix 2
v27.10.0800 - 2025-08-01 11:00
    - feat 1
    - fix 2
v27.10.0800 - 2025-09-10 19:00
    - feat 1
```
This tool allows you to sort all change blocks by date in descending order (from new to old):
```js
v27.10.0800 - 2025-09-10 19:00
    - feat 1
v27.10.0800 - 2025-09-09 18:00
    - fix 1
    - fix 2
v27.10.0800 - 2025-08-01 11:00
    - feat 1
    - fix 2
```
You can copy the text directly into the UI, or you can open one or more files and click `Sort` to convert them:
![copy paste](https://github.com/user-attachments/assets/6d3d7e8c-05b6-4611-8a9d-4750b937f696)

You can also merge multiple files. Drag and drop all files into the UI:
![drag and drop](https://github.com/user-attachments/assets/e26a5bd1-384c-4983-80d3-1676f5f29c2c)

If the files are located in different directories, you can use the `Open` button.
> [!TIP]
> You can use [QuickSwitch](https://github.com/JoyHak/QuickSwitch) for quick navigation in the file dialog.

![open multiple](https://github.com/user-attachments/assets/63dfbe11-ef98-4256-99a9-4717516882d6)

After sorting, you can copy the merged text or save it to a new file (the encoding will be `UTF-8`). Here are the basic principles for searching blocks:
- Blocks must begin with the version, e.g. “v27.10.0800”. The version serves as a separator between blocks.
- Empty lines following a block (after the version) belong to that block and are not deleted. Empty lines preceding a block (before the version) belong to the previous block.
- Blocks must contain dates or other sorting keys (see details below).
- Blocks that contain identical dates (or other sorting keys) are deleted before sorting, starting with the second duplicate found and continuing onwards. Duplicates are deleted sequentially according to the text entered.

### Sorting
You can also specify a [regular expression](https://www.geeksforgeeks.org/dsa/write-regular-expressions/) (RegEx) for dates using [Perl syntax](https://www.boost.org/doc/libs/1_85_0/libs/regex/doc/html/boost_regex/syntax/perl_syntax.html). It will be used to extract the date from each block. Subsequently, each date, hour, minute, and second (if time is found) will be used for sorting. For example, you can specify a RegEx for the format `00:00:01:0001` to sort blocks by milliseconds and seconds if they have the same hours and minutes (`00:00`).

Potentially, you can specify any RegEx to search for any string, number or letter. It affects sorting as follows:
- Numbers sorted in descending order (from largest to smallest).
- Strings sorted lexicographically (alphabetically, from `Z` to `A`). Sorting is case-sensitive by default ("apple" comes before "Apple").
- Dates If stored as strings in `YYYY-MM-DD HH:MM` format or in ISO 8601 (e.g., "2025-09-16T11:40:54Z") format, sorted from left to right: by year, then by month, then by day, then by time (including any milliseconds or nanoseconds if any). It means that.
    - If the format is different (e.g., `DD-MM-YYYY` or `MM/DD/YYYY`), lexicographical sorting will **not** match chronological order. In `MM/DD/YYYY` format, sorting compares characters from left to right: month, then day, then year. This causes months to be sorted before years, so after "01/01/2025" will be "01/01/2024" (all January dates from all years come before February, regardless of the year).
    - Custom formats (e.g., `Sep 16, 2025`, `16 Sep 2025`) do not sort correctly because sorting is done by the first word: the month name or day, not by year or actual date, causing incorrect order. Month names (`Jan`, `Feb`, `Mar`, etc.) are sorted alphabetically. So after "Apr 16, 2025" will be "Feb 16, 2025".
    - Only formats starting with the year (`YYYY-MM-DD`, `YYYY/MM/DD`, `YYYYMMDD`, ISO 8601) are reliably sortable as strings in chronological order. All other formats can produce incorrect or confusing sorting unless parsed and compared as actual date objects.
    - The date and time separator (as well as their complete absence) doesn't matter. These dates are identical from a sorting perspective: 2025-09-16 18:00, 2025.09.16 18:00, 2025:09:16 18.00, 20250916 1800

Common apturing groups `()` are not ignored (everything that matches the entire RegEx pattern is captured). Look-ahead and look-behind assertions `(?=..)`, `(?!..)`, ... are supported. You can specify flags (options) like `(?im)` at the very beginning of a regular expression. Specify zero or more of the [following options](https://www.autohotkey.com/docs/v2/misc/RegEx-QuickRef.htm#Options) followed by a close-parenthesis (`im)` instead of `(?im)`. For example, the pattern `im)abc` would search for "abc" with the case-insensitive and multiline options (the parenthesis may be omitted when there are no options). Although this syntax breaks from tradition, it requires no special delimiters (such as forward-slash), and thus there is no need to escape such delimiters inside the pattern. In addition, performance is improved because the options are easier to parse.

You can find all supported and special options here: https://www.autohotkey.com/docs/v2/misc/RegEx-QuickRef.htm
Here you can find additional patterns: https://www.boost.org/doc/libs/1_85_0/libs/regex/doc/html/boost_regex/syntax/perl_syntax.html
