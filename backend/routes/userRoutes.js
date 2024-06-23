const express = require('express');
const UserController = require('../controllers/UserController');
const UploadController = require('../controllers/UploadController');

const userController = new UserController();
const router = express.Router();

// Rute untuk registrasi dengan upload gambar
router.post('/register', (req, res) => userController.register(req, res));
// Rute untuk login
router.post('/login', (req, res) => userController.login(req, res));

module.exports = router;
