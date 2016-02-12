require 'json'

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end

def start
	setup_files
	create_report
end

start

puts
d = Time.now.strftime("%m/%d/%Y")
puts "Report generated: #{d}"

puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "
puts

products_hash["items"].each do |item|
  puts "Toy: #{item["title"]}" #prints the name of each toy

  retail_price = item["full-price"] #gets retail price for each toy
  puts "Retail price: $#{retail_price}" #prints the full price of each toy

  sales_total = item["purchases"].length #calculates the total number of sales for each item
  puts "Total number of purchases: #{sales_total}" #prints the total number of sales for each item

  price_total = 0 #initializes a price total
  price_avg = 0 #initializes a price average
  item["purchases"].each do |purchase| #iterates through purchases
    price_total += purchase["price"].to_f #calculates total dollar amount the item sold for
      price_avg = (price_total.to_f / sales_total.to_f) #calculates average of sale price
  end
  puts "Total amount of sales: $#{price_total.to_s}" #prints the total dollar amount the item has sold for

  puts "Average sale price: $#{price_avg.to_s}" #prints the average price the item has sold for

  discount = (retail_price.to_f - price_avg.to_f) #calucaltes retail price - average price paid to get discounted amount
  puts "Average discount: $#{discount.round(2)}" #prints average discount

  puts "-------------------------------------"
end


	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts
puts

unique_brands = products_hash["items"].map { |item| item["brand"] }.uniq #iterates each toy
  unique_brands.each_with_index do | brand, index | #iterates toy by brand
    puts "Brand: #{brand}" #prints brand names

  brands_toys = products_hash["items"].select { |item| item["brand"] == brand }
  toys_per_brand = brands_toys.length #calculates number of toys per brand (not stock amount of those toys)
  stock_brand = 0
  brands_toys.each {|toy| stock_brand += toy["stock"].to_f} #calculates number of toys in stock
  puts "Number of toys we sell from this brand: #{toys_per_brand}" #prints number of toys sold by this brand
  puts "Total number of toys in stock from this brand: #{stock_brand.to_i}" #prints number of toys in stock for this brand

  brand_price_total = 0 #initializes total price of brand's toys
  brands_toys.each {|toy| brand_price_total += toy["full-price"].to_f} #iterates the price of each toy
  avg_brand_price = 0 #initializes average price of brand's toys
  avg_brand_price = brand_price_total / toys_per_brand #calculates average price of brand's toys
  puts "Average price of toys we sell by this brand: $#{avg_brand_price.round(2)}" #prints average price of brand's toys

  brand_sales = 0 #initializes brand's toy sales amount
  brands_toys.each do |item| #iterates each toy
    item ["purchases"].each do |el| #iterates each sale
      brand_sales += el["price"].to_f #counts total price of sales
    end
  end
  puts "Total revenue of all sales for this brand: $#{brand_sales.round(2)}" #prints total revenue

  puts "-----------------------------------------------------"
  end
