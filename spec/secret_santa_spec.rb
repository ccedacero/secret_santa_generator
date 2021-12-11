# frozen_string_literal: true

require 'spec_helper'
require_relative '../bin/santa_tracker'
require 'json'

describe '#validate_input' do
  context 'when given no source or destination file names' do
    it 'should raise an ArgumentError' do
      expect { validate_input(['arg']) }.to raise_error(ArgumentError)
    end
  end

  context 'when given an empty source file' do
    it 'should raise an ArgumentError' do
      expect { validate_input('spec/fixtures/empty_names_file.txt', 'santas.txt') }.to raise_error(ArgumentError)
    end
  end
end

describe '#generate_unique_combinations' do
  context 'when given an array of names' do
    let(:names) { ['Jack Skellington', 'Yukon Cornelius', 'John McClane', 'Krampus'] }
    it 'should generate random unique name combinations' do
      first_combination = generate_unique_combinations(names)
      second_combination = generate_unique_combinations(names)
      expect(first_combination.to_json).not_to eq(second_combination.to_json)
    end
  end
end

describe '#process' do
  context 'when given two valid files' do
    let(:combination) { File.read('spec/fixtures/empty_names_file.txt') }
    it 'should output valid secret santa matches' do
      allow(File).to receive(:close).with(combination)
      process('spec/fixtures/valid_names.txt', 'santas.txt')
      File.delete('santas.txt')
    end
  end
end
