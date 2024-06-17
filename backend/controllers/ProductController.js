const { Product, User, Category } = require('../models');
const UploadController = require('../controllers/UploadController');

class ProductController {
  async getAllProducts(req, res) {
    try {
      const products = await Product.findAll();
      res.json(products);
    } catch (err) {
      console.error('Error fetching products:', err);
      res.status(500).json({ error: 'Failed to fetch products' });
    }
  }

  async getProductById(req, res) {
    try {
      const { id } = req.params;
      const product = await Product.findByPk(id);
      if (!product) {
        return res.status(404).json({ error: 'Product not found' });
      }
      res.json(product);
    } catch (err) {
      console.error('Error fetching product:', err);
      res.status(500).json({ error: 'Failed to fetch product' });
    }
  }

  async createProduct(req, res) {
    try {
      const { name, qty, categoryId, createdBy, updatedBy } = req.body;
      let urlImage = null;

      if (req.file) {
        urlImage = `/images/products/${req.file.filename}`;
      }

      const product = await Product.create({
        name,
        qty,
        categoryId,
        urlImage,
        createdBy,
        updatedBy,
      });

      res.status(201).json({ message: 'Product has been created successfully' });
    } catch (err) {
      console.error('Error creating product:', err);
      res.status(500).json({ error: 'Failed to create product' });
    }
  }

  async updateProduct(req, res) {
    try {
      const { id } = req.params;
      const { name, qty, categoryId, urlImage, createdBy, updatedBy } = req.body;
      const product = await Product.findByPk(id);
      if (!product) {
        return res.status(404).json({ error: 'Product not found' });
      }
      await product.update({ name, qty, categoryId, urlImage, createdBy, updatedBy });
      res.json({ message: 'Product has been updated successfully' });
    } catch (err) {
      console.error('Error updating product:', err);
      res.status(500).json({ error: 'Failed to update product' });
    }
  }

  async deleteProduct(req, res) {
    try {
      const { id } = req.params;
      const product = await Product.findByPk(id);
      if (!product) {
        return res.status(404).json({ error: 'Product not found' });
      }
      await product.destroy();
      res.status(200).json({ message: 'Product has been deleted successfully' });
    } catch (err) {
      console.error('Error deleting product:', err);
      res.status(500).json({ error: 'Failed to delete product' });
    }
  }
}

module.exports = ProductController;