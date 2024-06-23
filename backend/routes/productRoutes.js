const express = require('express');
const ProductController = require('../controllers/ProductController');
const UploadController = require('../controllers/UploadController');

const router = express.Router();

const productController = new ProductController();

router.use(express.json());

router.get('/', productController.getAllProducts);
router.get('/:id', productController.getProductById);
router.post('/create', UploadController.upload('products'), (req, res) => productController.createProduct(req, res));
router.put('/:id', UploadController.upload('products'), (req, res, next) => {
  console.log(`PUT /products/${req.params.id}`);
  next();
}, productController.updateProduct);
router.delete('/:id', productController.deleteProduct);

module.exports = router;