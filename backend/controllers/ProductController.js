const { Product, User, Category } = require('../models')


class ProductController{
    async getAllProducts(req, res) {
        try {
            const products = await Product.findAll();
            res.json(products)
        } catch (err) {
            res.status(500).json({ err: 'Failed to fetch products'})
        }
    }
    async getProductById(req, res) {
        try {
            const { id } = req.params;
            const product = await Product.findByPk(id);
            if (!product) {
                return res.status(400).json({ err : 'Product not found '})
            }
            res.json(product)
        } catch (err) {
            res.status(500).json({ err : " Failed to fetch product" })
        }
    }
    async createProduct(req, res) {
        try {
            const { name, qty, categoryId, urlImage, createdBy, updatedBy } = req.body;
            const product = await Product.create({ name, qty, categoryId, urlImage, createdBy, updatedBy });
            res.status(200).json({ err: 'Product has been created successfully '})
        } catch (err) {
            console.error('Error creating product:', err);
            res.status(500).json({ err : 'Failed to create product' })
        }
    }
    async updateProduct(req, res) {
        try {
            const { id } = req.params;
            const { name, qty, categoryId, urlImage, createdBy, UpdatedBy } = req.body;
            const product = await Product.findByPk(id);
            if (!product) {
                return res.status(404).json({ err: 'Product not found'})
            }
            await product.update({ name, qty, categoryId, urlImage, createdBy, UpdatedBy });
            res.json({ message: ' Product has been updated successfully'})
        } catch (err) {
            res.status(500).json({ err : 'Failed to update product '})
        }
    }
    async deleteProduct(req, res) {
        try {
            const { id } = req.params;
            const product = await Product.findByPk(id);
            if (!product) {
                return res.status(404).json({ err: 'Product not found'})
            }
            await product.destroy();
            res.status(500).json({err : 'Product has been deleted successfully'})
        } catch (err) {
            res.status(500).json({ err: 'Failed to delete product'})
        }
    }
    async uploadImage(req, res) {
        try {
            console.log(`Received productId:`,req.body.productId);
            console.log(`Uploading image to:`, req.file);
            if (!req.file) {
                return res.status(400).json({ err : 'No file uploaded'})
            }

            //Simpan gambar ke database

            const { productId } = req.body;
            const imageUrl = `/images/products${req.file.filename}`;

            if (!Number(productId)) {
                console.log('Invalid productId');
                return res.status(400).json({ err: 'Invalid productId '})
            }
            const product = await Product.findByPk(productId);
            if (!product) {
                return res.status(404).json({ err : 'Product not found'})
            }
            await product.update({ urlImage: imageUrl });
            res.status(200).json({message : 'Image has been uploaded successfully'})
        } catch (err) {
            
        }
    }
}
module.exports = ProductController;