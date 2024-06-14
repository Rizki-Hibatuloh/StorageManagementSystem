const express        = require('express')
const userRoutes     = require('./userRoutes')
const categoryRoutes = require('./categoryRoutes')
const productRoutes = require('./productRoutes')

const router = express.Router();
router.use('/users', userRoutes)
router.use('/categories', categoryRoutes)
router.use('/products', productRoutes)

module.exports = router;