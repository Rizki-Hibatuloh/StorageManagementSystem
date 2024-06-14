const { Category } = require('../models')


class CategoryController{
    async getAllCategories(req, res) {
        try { 
            const categories = await Category.findAll();
            res.json(categories)
        } catch (err) {
            res.status(500).json({ err : 'Failed to fetch categories'})
        }
    }

    async createCategories(req, res) {
        try {
            const { name } = req.body;
            const newCategory = await Category.create({ name })
            res.status(201).json({ message : 'Category has been created successfully '})
        } catch (err) {
            res.status(500).json({ err : 'Failed to  create Category'})
        }
    }
}

module.exports = CategoryController;