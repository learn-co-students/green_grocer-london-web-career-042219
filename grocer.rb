require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |shopping_hash|
    shopping_hash.each do |item_name, price_hash|
      if new_hash[item_name].nil?
        new_hash[item_name] = price_hash.merge({:count => 1})
      else
        new_hash[item_name][:count] += 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  combined_hash = Marshal.load(Marshal.dump(cart))
#  combined_hash = cart.clone
  coupons.each do |x|
    if combined_hash[x[:item]] != nil && combined_hash[x[:item]][:count] >= x[:num]
      new_item = "#{x[:item]} W/COUPON"
      combined_hash[new_item] = combined_hash[x[:item]].clone
      combined_hash[new_item][:price] = x[:cost]
      combined_hash[new_item][:count] = cart[x[:item]][:count]/x[:num]

      combined_hash[x[:item]][:count] -= x[:num]
    end
  end
  combined_hash
end

def apply_clearance(cart)
  new_hash = Marshal.load(Marshal.dump(cart))

  new_hash.each do |item, info|
    if info[:clearance] == true
      discount = info[:price]*0.20
      new_hash[item][:price] = info[:price] - discount
    end
  end
  new_hash
end

def checkout(cart, coupons)
  cart0 = consolidate_cart(cart)
  cart1 = apply_coupons(cart0, coupons)
  cart2 = apply_clearance(cart1)

  total = 0

  cart2.each do |key, value|
    total += value[:price] * value[:count]
  end

  if total >= 100
    discount = total * 0.10
    total = total - discount
  end
  total
end


#:items
#  [
#    {"AVOCADO" => {:price => 3.00, :clearance => true}},
#    {"KALE" => {:price => 3.00, :clearance => false}},
#    {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
#    {"ALMONDS" => {:price => 9.00, :clearance => false}},
#    {"TEMPEH" => {:price => 3.00, :clearance => true}},
#    {"CHEESE" => {:price => 6.50, :clearance => false}},
#    {"BEER" => {:price => 13.00, :clearance => false}},
#    {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
#    {"BEETS" => {:price => 2.50, :clearance => false}},
#    {"SOY MILK" => {:price => 4.50, :clearance => true}}
#  ]
