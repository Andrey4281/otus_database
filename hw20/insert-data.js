db.product.insertMany( [
    {
        name: 'Refrigerator'
    },
    {
        name: 'Washing machine'
    },
    {
        name: 'Dishwasher'
    },
    {
        name: 'Oven'
    },
    {
        name: 'Microwave'
    },
    {
        name: 'Coffee maker'
    },
    {
        name: 'Toaster'
    }
] )

db.productItem.insertMany( [
    {
        supplier: 'Entrepreneur',
        product: 'Refrigerator',
        price: 10000.20,
        amount: 10.00
    },
    {
        supplier: 'Entrepreneur',
        product: 'Washing machine',
        price: 20000.00,
        amount: 20.00
    },
    {
        supplier: 'Entrepreneur',
        product: 'Dishwasher',
        price: 5000.00,
        amount: 30.00
    },
    {
        supplier: 'Entrepreneur',
        product: 'Oven',
        price: 10000.00,
        amount: 12.00
    },
    {
        supplier: 'Entrepreneur',
        product: 'Microwave',
        price: 3000.00,
        amount: 17.00
    },
    {
        supplier: 'Entrepreneur',
        product: 'Coffee maker',
        price: 1500.00,
        amount: 18.00
    },
    {
        supplier: 'Entrepreneur',
        product: 'Toaster',
        price: 1000.00,
        amount: 19.00
    }
] )