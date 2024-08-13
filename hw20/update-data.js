db.productItem.replaceOne({$and : [{product: "Refrigerator"}, {supplier: "Entrepreneur"}]},
    {
        supplier: 'Entrepreneur',
        product: 'Food scale',
        price: 5000.20,
        amount: 1000.00
    }
)

db.productItem.find( {$and : [{product: "Food scale"}, {supplier: "Entrepreneur"}]} )

db.product.updateOne({name : "Oven"}, {$set: {name : "Mandoline"}})

db.product.find( { name: 'Mandoline'} )
