require 'json'
require 'artii'
require 'date'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
 # $report_file = File.new("report.txt", "w+")
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

def print_item_data(item)
  print_to_report "Toy: #{item["title"]}" #prints the name of each toy 
  retail_price = retail_price_method(item)
  sales_total = sales_total_method(item)
  price_total = price_total_method(item)
  price_avg = price_avg_method(price_total, sales_total)
  discount_method(retail_price, price_avg)
end

def retail_price_method(item)
  retail_price = item["full-price"] #gets retail price for each toy 
  print_to_report "Retail price: $#{retail_price}" #prints the full price of each toy 
  return retail_price
end

def sales_total_method(item)
  sales_total = item["purchases"].length #calculates the total number of sales for each item 
  print_to_report "Total number of purchases: #{sales_total}" #prints the total number of sales for each item 
  return sales_total
end

def discount_method(retail_price, price_avg)
  discount = (retail_price.to_f - price_avg.to_f) #calucaltes retail price - average price paid to get discounted amount 
  print_to_report "Average discount: $#{discount.round(2)}" #prints average discount 
  return discount 
end

def price_total_method(item)
  price_total = 0
  item["purchases"].each do |purchase|
    price_total += purchase["price"].to_f
  end
  print_to_report "Total amount of sales: $#{price_total.to_s}" #prints the total dollar amount the item has sold for 
  return price_total 
end

def price_avg_method(price_total, sales_total)
  price_avg = (price_total.to_f / sales_total.to_f) #calculates average of sale price 
  print_to_report "Average sale price: $#{price_avg.to_s}" #prints the average price the item has sold for 
  return price_avg
end

def make_brands_section
  print_heading("Brands")
  brands
end

def brands
  unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq #iterates each toy 
  unique_brands.each_with_index do | brand, index | #iterates toy by brand 
    print_brand_data(brand)
    print_to_report "-----------------------------------------------------"
  end
end

def print_brand_data(brand)  
  print_to_report "Brand: #{brand}" #prints brand names 
  brands_toys = brands_toys_method(brand)
  toys_per_brand = toys_per_brand_method(brands_toys)
  stock_brand_method(brands_toys)
  avg_brand_price_method(brands_toys, toys_per_brand)
  brand_sales_method(brands_toys)
end

def brands_toys_method(brand) #parses toys per brand 
  brands_toys = $products_hash["items"].select { |item| item["brand"] == brand }
  return brands_toys
end
  
def toys_per_brand_method(brands_toys) #total number of toys sold by this brand 
  toys_per_brand = brands_toys.length #calculates number of toys per brand (not stock amount of those toys)
  print_to_report "Number of toys we sell from this brand: #{toys_per_brand}" #prints number of toys sold by this brand 
  return toys_per_brand
end

def stock_brand_method(brands_toys)
  stock_brand = 0 
  brands_toys.each {|toy| stock_brand += toy["stock"].to_f} #calculates number of toys in stock 
  print_to_report "Total number of toys in stock from this brand: #{stock_brand.to_i}" #prints number of toys in stock for this brand 
  return stock_brand
end
  
def avg_brand_price_method(brands_toys, toys_per_brand)
  brand_price_total = 0 #initializes total price of brand's toys 
  brands_toys.each {|toy| brand_price_total += toy["full-price"].to_f} #iterates the price of each toy 
  avg_brand_price = brand_price_total / toys_per_brand #calculates average price of brand's toys 
  print_to_report "Average price of toys we sell by this brand: $#{avg_brand_price.round(2)}" #prints average price of brand's toys
  return avg_brand_price
end
  
def brand_sales_method(brands_toys)
  brand_sales = 0 #initializes brand's toy sales amount 
  brands_toys.each do |item| #iterates each toy 
     item["purchases"].each do |el| #iterates each sale 
        brand_sales += el["price"].to_f #counts total price of sales 
     end
   end
  print_to_report "Total revenue of all sales for this brand: $#{brand_sales.round(2)}" #prints total revenue
  return brand_sales
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