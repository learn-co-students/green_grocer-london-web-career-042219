require 'pry'
def consolidate_cart(cart)
 items = []
  cart.each {|item_hash|               #list item names in array
    item_hash.each{|name,att_hash|
      items << name
    }
  }
  item_number = {}

  items.each {|item|                 #count the number of each item
    item_number[item] = items.count(item)
  }
  return_hash = {}                  #form a new hash with the added count
  cart.each {|item_hash|
    item_hash.each{|name,att_hash|
      att_hash[:count] = item_number[name]
      return_hash[name] = att_hash
    }
  }
  return_hash
end
#1 conslidate cart using above?
#2 check if any of the coupons apply to any items in the cart
    #collect all item names from cart in array
    #iterate through coupons and ask if .include?(:item) in Array
#3 If so, iterate through coupons:
  #A. subtract the coupon num from the cart count
  #B add new key/value to cart.clone with "item W/Coupon"

def apply_coupons(cart, coupons)
  new_cart = cart.clone
  cart_clone = Marshal.load(Marshal.dump(cart)) #Copies the hash 'cart' {with zero connections}
  if coupons != []
    coupons.each {|coupon|
      i = 0                                 #reset counter for each coupon
      cart.each {|item_key,item_hash|
          while coupon[:item] == item_key && item_hash[:count] >= coupon[:num]     #loops until not enough to apply coupon
            i += 1
            item_hash[:count] = item_hash[:count] - coupon[:num]
            new_cart[item_key + " #{"W/COUPON"}"] = {:price => coupon[:cost], :clearance => item_hash[:clearance], :count => i}
          end
      }
    }
 end
  new_cart
end

def apply_clearance(cart)
  cart_clone = Marshal.load(Marshal.dump(cart))
  cart.each {|name,atts|
    if atts[:clearance] == true
      atts[:price] = atts[:price]*0.8
      atts[:price] = atts[:price].round(2)
    end
  }
  cart
end

def checkout(cart, coupons)
  # calculate the total cost of a cart of items & apply discount and coupons as nec
  #relys on the above methods
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  total = 0
  cart.each {|item,att_hash|
    total += att_hash[:price]*att_hash[:count]
  }

  if total > 100
    total = (total*0.9)
  end
  
  total
end
