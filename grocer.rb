def consolidate_cart(cart)
  # code here
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

def apply_coupons( cart, coupons )

  return_cart = cart
  counter = 0
  coupons.each do
    if cart[ coupons[counter][:item] ]
      item_name=coupons[counter][:item]
      coupon_count=coupons[counter][:num]
      cart_count=return_cart[coupons[counter][:item]][:count]
    
# old code, when I hadnt understood coupon counts      
#      if apply_count>0
      if coupon_count<=cart_count
        apply_count=coupon_count
        voucher_name = "#{coupons[counter][:item]} W/COUPON"
        if !return_cart[voucher_name]
          return_cart[voucher_name]={}
          return_cart[voucher_name][:price]=coupons[counter][:cost]
          return_cart[voucher_name][:clearance]=return_cart[item_name][:clearance]
          return_cart[voucher_name][:count]=0
        end
        return_cart[voucher_name][:count]+=1
        return_cart[item_name][:count]=cart_count-apply_count
      end

    end
    counter+=1
  end

  return_cart
end

def apply_clearance( cart )
  # code here
  #{
  #"PEANUTBUTTER" => {:price => 3.00, :clearance => true,  :count => 2},
  #"KALE"         => {:price => 3.00, :clearance => false, :count => 3}
  #"SOY MILK"     => {:price => 4.50, :clearance => true,  :count => 1}
  #}

  cart.each do | k , v |
    if cart[k][:clearance]==true
      cart[k][:price]=(0.8*cart[k][:price]).round(1)
    end  
  end

end

def apply_final_discounts( cart )

  total_price=0
  return_price=0

  cart.each do | k , v |
    total_price+=cart[k][:price]*cart[k][:count]
 #   puts "#{k} #{v} total price #{total_price}"
  end

  if total_price>100
    return_price=(total_price*0.9).round(2)
  else
    return_price=total_price
  end

  return_price
  
end

def checkout(cart, coupons)
  # code here
  my_cart=consolidate_cart(cart)
  my_cart=apply_coupons(my_cart, coupons)
  my_cart=apply_clearance( my_cart )
  total_price=apply_final_discounts( my_cart )

  total_price

end
