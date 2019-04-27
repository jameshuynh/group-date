# Group Date function

This class function is used to return a string based on an input list of dates. It would try to group dates into month and year in order to generate out a string to represent that list.

## Usage

```rb
group_date = GroupDate.new(
  [
    Date.parse('01-01-2019'),
    Date.parse('02-01-2019')
  ]
)

group_date.call
# => 01 Jan and 02 Jan 2019


group_date = GroupDate.new(
  [
    Date.parse('29-12-2019'),
    Date.parse('30-12-2019'),
    Date.parse('02-01-2020'),
    Date.parse('03-01-2020'),
    Date.parse('05-01-2020')
  ]
)

group_date.call
# => 29 to 30 Dec 2019, 02 to 03 Jan and 05 Jan 2020
```

## To run test

```bash
ruby group_date_test.rb
```
