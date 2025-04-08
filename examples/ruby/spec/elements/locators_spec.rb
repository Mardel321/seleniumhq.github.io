# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Element Locators' do
  before do
    start_session
    driver.navigate.to('https://www.selenium.dev/selenium/web/web-form.html')
  end

  let(:driver) { @driver }
  let(:expected_elements) do
    {text_field: driver.find_element(id: 'my-text-id'),
     password: driver.find_element(name: 'my-password'),
     dropdown: driver.find_element(name: 'my-select'),
     radio: driver.find_element(id: 'my-radio-2'),
     link: driver.find_element(tag_name: 'a')}
  end

  it 'finds element by class name' do
    element = driver.find_element(class: 'form-control')

    expect(element).to eq(expected_elements[:text_field])
  end

  it 'finds element by id' do
    element = driver.find_element(id: 'my-text-id')

    expect(element).to eq(expected_elements[:text_field])
  end

  it 'find element by name' do
    element = driver.find_element(name: 'my-text')

    expect(element).to eq(expected_elements[:text_field])
  end

  it 'finds element by tag name' do
    element = driver.find_element(tag_name: 'input')

    expect(element).to eq(expected_elements[:text_field])
  end

  it 'finds element by css selector' do
    element = driver.find_element(css: '.form-control[name$=text]')

    expect(element).to eq(expected_elements[:text_field])
  end

  it 'finds element by xpath' do
    xpath = "//*[contains(@class, 'form-control') and substring(@name, string-length(@name) - 3) = 'text']"
    element = driver.find_element(xpath: xpath)

    expect(element).to eq(expected_elements[:text_field])
  end

  it 'finds element by link text' do
    element = driver.find_element(link_text: 'Return to index')

    expect(element).to eq(expected_elements[:link])
  end

  it 'finds element by partial link text' do
    element = driver.find_element(partial_link_text: 'Return')

    expect(element).to eq(expected_elements[:link])
  end

  context 'with relative locators' do
    it 'finds element above' do
      element = driver.find_element({relative: {tag_name: 'input', above: {name: 'my-password'}}})

      expect(element).to eq(expected_elements[:text_field])
    end

    it 'finds element below' do
      element = driver.find_element({relative: {tag_name: 'input', below: {id: 'my-text-id'}}})

      expect(element).to eq(expected_elements[:password])
    end

    it 'finds element to the left' do
      element = driver.find_element({relative: {tag_name: 'input', left: {name: 'my-select'}}})

      expect(element).to eq(expected_elements[:text_field])
    end

    it 'finds element to the right' do
      element = driver.find_element({relative: {tag_name: 'select', right: {id: 'my-text-id'}}})

      expect(element).to eq(expected_elements[:dropdown])
    end

    it 'finds near element' do
      element = driver.find_element({relative: {tag_name: 'input', near: {name: 'my-password'}}})

      puts "#{element.tag_name}: #{element.attribute('id')}"
      expect(element).to eq(expected_elements[:text_field])
    end

    it 'chains relative locators' do
      element = driver.find_element({relative: {tag_name: 'input', below: {name: 'my-select'},
                                                right: {tag_name: 'a'}}})

      expect(element).to eq(expected_elements[:radio])
    end
  end
end
