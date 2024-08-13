db.product.find({ name: 'Refrigerator'})

db.product.find(
    { name: { $in: [ 'Refrigerator', 'Coffee maker', 'Toaster' ] } }
)

db.productItem.find( { price: { $gt: 1000, $lt: 10000.20 } } )

db.productItem.aggregate( [ {$group :{ _id : "productItem", total_price: { $sum : "$price" }}} ] )

db.productItem.aggregate( [ {$group :{ _id : "productItem", total_price: { $sum: { $multiply: ['$price', '$amount'] } }}} ] )

db.productItem.aggregate([ { "$lookup": { "from": "product", "localField": "product", "foreignField": "name", "as": "productName" } }] )