#!/usr/bin/env ruby
# frozen_string_literal: true

def process(names_source_file, santa_matches_destination_file)
  matched_secret_santas = File.open(santa_matches_destination_file, 'w+')

  names_to_match = File.read(names_source_file).split("\n")

  matched_secret_santa_names = generate_unique_combinations(names_to_match)

  matched_secret_santa_names.each do |combination|
    matched_secret_santas << "#{combination[0]} -> #{combination[1]} \n"
  end

  matched_secret_santas.close
  puts File.read(matched_secret_santas)
end

def generate_unique_combinations(names_array)
  chosen_combinations = {}

  possible_santa_combinations = names_array.permutation(2).to_a.shuffle

  possible_santa_combinations.each do |combination|
    next if chosen_combinations.values.include?(combination[1]) && chosen_combinations.keys.include?(combination[0])

    chosen_combinations[combination[0]] = combination[1]
  end
  chosen_combinations
end

def validate_input(arguments)
  if arguments.count < 2
    raise ArgumentError,
          "Expected two file arguments, but got #{arguments.count}"
  end
  names = File.read(arguments[0]).split("\n")
  return unless names.count.zero?

  raise ArgumentError,
        "Expected names to be present in source file, but got #{names.count}"
end

if $PROGRAM_NAME == __FILE__
  validate_input(ARGV)
  process(ARGV[0], ARGV[1])
end
