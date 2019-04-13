def consolidate_cart(cart)
  consolidated_cart={}
  counter=0

   cart.each do

     cart[counter].each do |k,v|
      if consolidated_cart[k]
        consolidated_cart[k][:price]=cart[counter][k][:price]
        consolidated_cart[k][:clearance]=cart[counter][k][:clearance]
        consolidated_cart[k][:count]+=1
      else
        consolidated_cart[k]=cart[counter][k]
        consolidated_cart[k][:price]=cart[counter][k][:price]
        consolidated_cart[k][:clearance]=cart[counter][k][:clearance]
        consolidated_cart[k][:count]=1
      end
    end

     counter+=1
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  new_cart = cart

 coupons.each do | coupon |
  next unless new_cart[coupon[:item]]
  next unless new_cart[coupon[:item]][:count] >= coupon[:num]
  new_item = coupon[:item] + " W/COUPON"
  new_cart[new_item] ||= new_cart[coupon[:item]].merge({count:0})
  new_cart[new_item][:count] += 1
  new_cart[new_item][:price] = coupon[:cost]
    new_cart[coupon[:item]][:count] -= coupon[:num]
end

 new_cart
end

def apply_clearance(cart)
  new_cart = cart

 new_cart.each do | item, data |
  next unless data[:clearance]
  data[:price] -= (data[:price] * 0.2).round(2)
end

 new_cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
 new_cart = apply_coupons(new_cart, coupons)
 new_cart = apply_clearance(new_cart)

  total = 0.00

  new_cart.each { | item, data |  total += data[:price] * data[:count] }

  total -= (total * 0.1).round(2)  if total > 100

  total
end
