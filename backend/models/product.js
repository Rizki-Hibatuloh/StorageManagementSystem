'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Product extends Model {
     
    static associate(models) {
      // define association here
      Product.belongsTo(models.Category, {
        foreignKey: 'categoryId', as: 'category'
      })
      Product.belongsTo(models.User, {
        foreignKey: 'createdBy', as: 'Creator'
      })
      Product.belongsTo(models.User, {
        foreignKey: 'updatedBy', as: 'Updater'
      })
    }
  }
  Product.init({
    name: DataTypes.STRING,
    qty: DataTypes.INTEGER,
    categoryId: DataTypes.INTEGER,
    urlImage: DataTypes.STRING,
    createdBy: DataTypes.STRING,
    updatedBy: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'Product',
  });
  return Product;
};