def consolidate_cart(items)
  items_keys = items.flat_map(&:keys)
  
  new_list = items.inject(:merge).map{|key, value| { key => value.merge(count: items_keys.count(key)) }}

  new_list.inject(:merge!)
end

def apply_coupons(cart, coupons)
  # code here
end

def apply_clearance(cart)
  # code here
end

def checkout(cart, coupons)
  # code here
end
