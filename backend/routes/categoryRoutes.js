const express = require('express')
const CategoryController = require('../controllers/CategoryController')
const categoryController = new CategoryController()

const router = express.Router();

router.get('/', (req, res) => categoryController.getAllCategories(req, res))
router.post('/add', (req, res) => categoryController.createCategories(req, res))

module.exports = router;