const express           = require('express')
const ProductController = require('../controllers/ProductController')
const productController = new ProductController();
const UploadController = require('../controllers/UploadController')

const router = express.Router();

router.get('/', productController.getAllProducts);
router.get('/:id', productController.getProductById);
router.post('/', productController.createProduct);
router.put('/:id', productController.updateProduct);
router.delete('/:id', productController.deleteProduct);

router.post('/upload', UploadController.upload('products'), (req, res) => {
    productController.uploadImage(req, res)
})

module.exports = router;