db.product.deleteOne({ name: 'Dishwasher' })

db.productItem.deleteMany(
    { name: { $in: [ 'Refrigerator', 'Coffee maker', 'Toaster' ] } }
)