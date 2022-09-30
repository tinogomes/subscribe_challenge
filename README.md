# Subsbribe challenge

Read on: https://gist.github.com/safplatform/792314da6b54346594432f30d5868f36#file-challenge-md

## Requirements

* Ruby 3.1+

## How to execute

`$ ruby app.rb [<input_file>]`

If there is not input_file argument, it will use standard Unix STDIN, like:

`$ ruby app.rb < input_file` or `cat input_file | ruby app.rb`

## Notes

1. The suggested entries in the challenge are found in files in the `carts` directory.
2. I Used a spreadsheet to understand how to calculate the sales tax and import duty for each item. https://docs.google.com/spreadsheets/d/1D07CsZEPhPTojmqeL-A5CO9B2xbjJYsVvJMh-AjwUAs/edit?usp=sharing
