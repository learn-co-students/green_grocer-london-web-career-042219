
def consolidate_cart(cart)

  consolidated = {}

  cart.each do | item |
    item.each do | title, data |
      consolidated[title] ||= data.merge({count:0})
      consolidated[title][:count] += 1
    end
  end

  consolidated
end


def apply_coupons(cart, coupons)

  new_cart = cart

  coupons.each do | coupon |
    # skip coupon if no such item
    next unless new_cart[coupon[:item]]
    # skip coupon if not enough of this item
    next unless new_cart[coupon[:item]][:count] >= coupon[:num]
    # add couponned item
    new_item = coupon[:item] + " W/COUPON"
    new_cart[new_item] ||= new_cart[coupon[:item]].merge({count:0})
    new_cart[new_item][:count] += 1
    new_cart[new_item][:price] = coupon[:cost]
    # remove items allocated to coupon
    ## -- tests want to keep original item w/count = 0
    ##if coupon[:num] < new_cart[coupon[:item]][:count]
      new_cart[coupon[:item]][:count] -= coupon[:num]
    ##else
    ##  new_cart.delete(coupon[:item])
    ##end
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
