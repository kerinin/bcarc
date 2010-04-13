#Factory.define :product do |p|
#  p.name "Factory-defined Product Name"
#  p.description "Description"
#  p.price 100
#  p.count_on_hand 1
#  p.available_on Time.gm( '1990' )
#  p.owner {|u| u.association(:seller) }
#end