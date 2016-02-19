require 'json'
require 'artii'
require 'date'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
end

def create_report
  print_heading("Sales Report")
  print_date
  make_products_section
  make_brands_section
end

def print_heading(header_name)
  header_ascii = Artii::Base.new
  print_to_report header_ascii.asciify(header_name)
end

def print_date
  d = Time.now.strftime("%m/%d/%Y")
  print_to_report "Report generated: #{d}"
end

def make_products_section
  print_heading("Products")
  products
end

def products 
  $products_hash["items"].each do |item|
    print_item_data(item)
    print_to_report "-------------------------------------"
  end
end

def print_item_data(item) #prints item's name, calls all item data methods and defines all item data variables 
  print_to_report "item: #{item["title"]}" #prints the name of each item 
  retail_price = retail_price_method(item) #defines retail price and calls retail method
  total_number_of_sales = total_number_of_sales_method(item) #defines total number of sales and calls total number of sales method
  total_revenue_amount = total_revenue_amount_method(item) #defines total revenue amount and calls total revenue amount method
  avg_purchase_price = avg_purchase_price_method(total_revenue_amount, total_number_of_sales) #defines avg purchase price and calls avg purchase price method
  avg_discount_method(retail_price, avg_purchase_price) #defines avg discount price and calls avg discount price method 
end

def retail_price_method(item) #loops through the retail price for each item 
  retail_price = item["full-price"] #gets retail price for each item 
  print_to_report "Retail price: $#{retail_price}" #prints the full price of each item 
  return retail_price #returns retail price variable 
end

def total_number_of_sales_method(item) #loops through the total number of sales for each item 
  total_number_of_sales = item["purchases"].length #calculates the total number of sales for each item 
  print_to_report "Total number of sales: #{total_number_of_sales}" #prints the total number of sales for each item 
  return total_number_of_sales #returns total number of sales variable 
end

def total_revenue_amount_method(item) #loops through the total revenue amount for each item 
  total_revenue_amount = 0 #initializes total revenue amount variable 
  item["purchases"].each do |purchase| #loops through purchases
    total_revenue_amount += purchase["price"].to_f #calculates total revenue amount for each purchase based on price 
  end
  print_to_report "Total amount of revenue from sales: $#{total_revenue_amount.to_s}" #prints the total dollar amount the item has sold for 
  return total_revenue_amount #returns total revenue amount variable 
end

def avg_purchase_price_method(total_revenue_amount, total_number_of_sales) #calculates avg purchase price for each item 
  avg_purchase_price = (total_revenue_amount.to_f / total_number_of_sales.to_f) #calculates average of sale price 
  print_to_report "Average sale price: $#{avg_purchase_price.to_s}" #prints the average price the item has sold for 
  return avg_purchase_price #return avg purchase price variable 
end

def avg_discount_method(retail_price, avg_purchase_price) #calculates the avg discount for items sold 
  avg_discount = (retail_price.to_f - avg_purchase_price.to_f) #calucaltes retail price - average price paid to get avg_discounted amount 
  print_to_report "Average avg_discount: $#{avg_discount.round(2)}" #prints average avg_discount 
  return avg_discount #returns avg discount amount 
end

def make_brands_section
  print_heading("Brands")
  brands
end

def brands
  unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq #iterates each item 
  unique_brands.each_with_index do | brand, index | #iterates item by brand 
    print_brand_data(brand)
    print_to_report "-----------------------------------------------------"
  end
end

def print_brand_data(brand)  
  print_to_report "Brand: #{brand}" #prints brand names 
  brands_items_iterated = brands_items_iterated_method(brand)
  items_from_this_brand = items_from_this_brand_method(brands_items_iterated)
  items_in_stock_from_brand_method(brands_items_iterated)
  avg_price_items_brand_method(brands_items_iterated, items_from_this_brand)
  brand_revenue_amount_method(brands_items_iterated)
end

def brands_items_iterated_method(brand) #loops through item data
  brands_items_iterated = $products_hash["items"].select { |item| item["brand"] == brand }
  return brands_items_iterated #returns parsed item data 
end
  
def items_from_this_brand_method(brands_items_iterated) #loops through items sold by this brand 
  items_from_this_brand = brands_items_iterated.length #calculates number of items per brand (not stock amount of those items)
  print_to_report "Number of items we sell from this brand: #{items_from_this_brand}" #prints number of items sold by this brand 
  return items_from_this_brand #returns items per brand variable 
end

def items_in_stock_from_brand_method(brands_items_iterated) #loops through items in stock for this brand 
  items_in_stock_from_brand = 0 #initializes items in stock variable 
  brands_items_iterated.each {|item| items_in_stock_from_brand += item["stock"].to_f} #calculates number of items in stock 
  print_to_report "Total number of items in stock from this brand: #{items_in_stock_from_brand.to_i}" #prints number of items in stock for this brand 
  return items_in_stock_from_brand #returns items in stock variable 
end
  
def avg_price_items_brand_method(brands_items_iterated, items_from_this_brand) #calculates avg sale price for items from each brand
  brand_total_revenue_amount = 0 #initializes total price of brand's items 
  brands_items_iterated.each {|item| brand_total_revenue_amount += item["full-price"].to_f} #iterates the price of each item 
  avg_price_items_brand = brand_total_revenue_amount / items_from_this_brand #calculates average price of brand's items 
  print_to_report "Average price of items we sell by this brand: $#{avg_price_items_brand.round(2)}" #prints average price of brand's items
  return avg_price_items_brand #returns avg price of items per brand variable 
end
  
def brand_revenue_amount_method(brands_items_iterated) #calculates revenue amount for each brand 
  brand_revenue_amount = 0 #initializes brand's item sales amount 
  brands_items_iterated.each do |item| #iterates each item 
     item["purchases"].each do |el| #iterates each sale 
        brand_revenue_amount += el["price"].to_f #counts total price of sales 
     end
   end
  print_to_report "Total revenue of all sales for this brand: $#{brand_revenue_amount.round(2)}" #prints total revenue
  return brand_revenue_amount #returns revenue amount for each brand variable 
end

def start
  setup_files
  create_report
end

def print_to_report(line)
  File.open("report.txt", "a") do |file|
    file.puts line
  end
end

start