const express = require('express');
const ProductController = require('../controllers/ProductController');
const UploadController = require('../controllers/UploadController');

const router = express.Router();
const productController = new ProductController();

router.get('/', productController.getAllProducts);
router.get('/:id', productController.getProductById);
router.post('/create', UploadController.upload('products'), (req, res) => productController.createProduct(req, res));
router.put('/update/:id', productController.updateProduct);
router.delete('/delete/:id', productController.deleteProduct);

module.exports = router;
