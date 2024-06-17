const express           = require('express')
const ProductController = require('../controllers/ProductController')
const productController = new ProductController();
const UploadController = require('../controllers/UploadController')

const router = express.Router();

router.get('/', productController.getAllProducts);
router.get('/:id', productController.getProductById);
router.post('/products/create', UploadController.upload('products'), (req, res) => productController.createProduct(req, res));

router.put('/update/:id', productController.updateProduct);
router.delete('/delete/:id', productController.deleteProduct);



module.exports = router;