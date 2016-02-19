require 'json'
require 'artii'

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

#prints item's name, calls all item data methods and defines all item data variables 
def print_item_data(item) 
  #prints the name of each item 
  print_to_report "item: #{item["title"]}" 
  #defines retail price and calls retail method
  retail_price = retail_price_method(item) 
  #defines total number of sales and calls total number of sales method
  total_number_of_sales = total_number_of_sales_method(item) 
  #defines total revenue amount and calls total revenue amount method
  total_revenue_amount = total_revenue_amount_method(item) 
  #defines avg purchase price and calls avg purchase price method
  avg_purchase_price = avg_purchase_price_method(total_revenue_amount, total_number_of_sales) 
  #defines avg discount price and calls avg discount price method 
  avg_discount_method(retail_price, avg_purchase_price) 
end

#loops through the retail price for each item
def retail_price_method(item)  
  #gets retail price for each item
  retail_price = item["full-price"]  
  #prints the full price of each item
  print_to_report "Retail price: $#{retail_price}"  
  #returns retail price variable
  return retail_price  
end

#loops through the total number of sales for each item
def total_number_of_sales_method(item)  
  #calculates the total number of sales for each item
  total_number_of_sales = item["purchases"].length  
  #prints the total number of sales for each item
  print_to_report "Total number of sales: #{total_number_of_sales}"  
  #returns total number of sales variable
  return total_number_of_sales  
end

#loops through the total revenue amount for each item
def total_revenue_amount_method(item)  
  #initializes total revenue amount variable
  total_revenue_amount = 0  
  #loops through purchases
  item["purchases"].each do |purchase| 
    #calculates total revenue amount for each purchase based on price 
    total_revenue_amount += purchase["price"].to_f 
  end
  #prints the total dollar amount the item has sold for 
  print_to_report "Total amount of revenue from sales: $#{total_revenue_amount.to_s}" 
  #returns total revenue amount variable 
  return total_revenue_amount 
end

#calculates avg purchase price for each item 
def avg_purchase_price_method(total_revenue_amount, total_number_of_sales) 
  #calculates average of sale price 
  avg_purchase_price = (total_revenue_amount.to_f / total_number_of_sales.to_f) 
  #prints the average price the item has sold for 
  print_to_report "Average sale price: $#{avg_purchase_price.to_s}" 
  #return avg purchase price variable
  return avg_purchase_price  
end

#calculates the avg discount for items sold
def avg_discount_method(retail_price, avg_purchase_price)  
  #calucaltes retail price - average price paid to get avg_discounted amount
  avg_discount = (retail_price.to_f - avg_purchase_price.to_f)  
  #prints average avg_discount
  print_to_report "Average discount: $#{avg_discount.round(2)}"  
  #returns avg discount amount
  return avg_discount  
end

def make_brands_section
  print_heading("Brands")
  brands
end

def brands
  #iterates each item
  unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq  
  #iterates item by brand
  unique_brands.each_with_index do | brand, index |  
    print_brand_data(brand)
    print_to_report "-----------------------------------------------------"
  end
end

def print_brand_data(brand)  
  #prints brand names
  print_to_report "Brand: #{brand}"  
  brands_items_iterated = brands_items_iterated_method(brand)
  items_from_this_brand = items_from_this_brand_method(brands_items_iterated)
  items_in_stock_from_brand_method(brands_items_iterated)
  avg_price_items_brand_method(brands_items_iterated, items_from_this_brand)
  brand_revenue_amount_method(brands_items_iterated)
end

#loops through item data
def brands_items_iterated_method(brand) 
  brands_items_iterated = $products_hash["items"].select { |item| item["brand"] == brand }
  #returns parsed item data
  return brands_items_iterated  
end
  
#loops through items sold by this brand 
def items_from_this_brand_method(brands_items_iterated) 
  #calculates number of items per brand (not stock amount of those items)
  items_from_this_brand = brands_items_iterated.length 
  #prints number of items sold by this brand 
  print_to_report "Number of items we sell from this brand: #{items_from_this_brand}" 
  #returns items per brand variable 
  return items_from_this_brand 
end

#loops through items in stock for this brand 
def items_in_stock_from_brand_method(brands_items_iterated) 
  #initializes items in stock variable 
  items_in_stock_from_brand = 0 
  #calculates number of items in stock 
  brands_items_iterated.each {|item| items_in_stock_from_brand += item["stock"].to_f} 
  #prints number of items in stock for this brand 
  print_to_report "Total number of items in stock from this brand: #{items_in_stock_from_brand.to_i}"
  #returns items in stock variable
  return items_in_stock_from_brand 
end

#calculates avg sale price for items from each brand
def avg_price_items_brand_method(brands_items_iterated, items_from_this_brand)
#initializes total price of brand's items  
  brand_total_revenue_amount = 0 
  #iterates the price of each item 
  brands_items_iterated.each {|item| brand_total_revenue_amount += item["full-price"].to_f} 
  #calculates average price of brand's items 
  avg_price_items_brand = brand_total_revenue_amount / items_from_this_brand 
  #prints average price of brand's items
  print_to_report "Average price of items we sell by this brand: $#{avg_price_items_brand.round(2)}" 
  #returns avg price of items per brand variable
  return avg_price_items_brand  
end

#calculates revenue amount for each brand
def brand_revenue_amount_method(brands_items_iterated)  
  #initializes brand's item sales amount
  brand_revenue_amount = 0  
  #iterates each item
  brands_items_iterated.each do |item|  
    #iterates each sale
    item["purchases"].each do |el|  
      #counts total price of sales 
      brand_revenue_amount += el["price"].to_f 
    end
  end
  #prints total revenue
  print_to_report "Total revenue of all sales for this brand: $#{brand_revenue_amount.round(2)}" 
  #returns revenue amount for each brand variable 
  return brand_revenue_amount 
end

def start
  setup_files
  create_report
end

def print_to_report(line)
  File.open("../report.txt", "a") do |file|
    file.puts line
  end
end


start