const express = require('express')
const UserController = require('../controllers/UserController')
const userController = new UserController();
const UploadController =require('../controllers/UploadController')

const router = express.Router();

router.post('/register', (req, res) => userController.register(req, res))
router.post('/login', (req, res) => userController.login(req, res))
router.post('/profile', UploadController.upload('profiles'), (req, res) => userController.uploadProfile(req, res))

module.exports = router;