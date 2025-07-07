require 'rexml/document'

# Load the XML file
file_path = 'data0421.xml'
unless File.exist?(file_path)
  puts "Error: #{file_path} not found."
  exit 1
end

begin
  doc = REXML::Document.new(File.new(file_path))
rescue REXML::ParseException => e
  puts "Error parsing XML: #{e.message}"
  exit 1
end

# Get all 'item' elements
items = doc.elements.to_a('//item')

# Check if there are items to sample
if items.empty?
  puts "No <item> elements found in the XML."
  exit
end

# Randomly sample 100 items
sampled_items = items.sample(100)

# Create a new XML document
new_doc = REXML::Document.new
new_doc << REXML::XMLDecl.new('1.0', 'UTF-8')

# Create the root element 'books'
books_root = new_doc.add_element('books')

# Add metadata if it exists in the original document
metadata = doc.root.elements['metadata']
books_root.add_element(metadata.deep_clone) if metadata

# Add the sampled items to the new document
sampled_items.each do |item|
  books_root.add_element(item.deep_clone)
end

# Overwrite the original file with the new smaller XML
File.open(file_path, 'w') do |f|
  new_doc.write(f, 2) # 2 is for indentation
end

puts "Successfully reduced #{file_path} to 100 random <item> elements."
