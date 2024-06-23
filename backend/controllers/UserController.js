const { User } = require('../models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'images/profiles');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
}).single('image'); // Nama field harus 'image'

class UserController {
async register(req, res) {
  upload(req, res, async (err) => {
    if (err) {
      return res.status(400).json({ err: 'File upload error' });
    }

    const { username, password } = req.body;
    const file = req.file;

    try {
      if (!username || !password) {
        return res.status(400).json({ err: 'All fields are required' });
      }

      // Check if username already exists
      const existingUser = await User.findOne({ where: { username } });
      if (existingUser) {
        return res.status(400).json({ err: 'Username is already taken' });
      }

      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);
      // Prepare image URL
      const imageUrl = file ? `/images/profiles/${file.filename}` : null;

      // Create new user
      const newUser = await User.create({ username, password: hashedPassword, image: imageUrl });

      // Return success message with user details
      res.status(201).json({ message: 'Registration successful', user: newUser });
    } catch (error) {
      console.error('Failed to register:', error);
      res.status(500).json({ err: 'Failed to register' });
    }
  });
}


  async login(req, res) {
    try {
      const { username, password } = req.body;

      if (!username || !password) {
        return res.status(400).json({ err: 'All fields are required' });
      }

      const user = await User.findOne({ where: { username } });
      if (!user || !await bcrypt.compare(password, user.password)) {
        return res.status(401).json({ err: 'Invalid username or password' });
      }

      const token = jwt.sign({ id: user.id }, 'secret', { expiresIn: '1h' });
      res.json({ status: 'Login Successful', token, image: user.image });
    } catch (err) {
      res.status(500).json({ err: 'Failed to login' });
    }
  }
}

module.exports = UserController;
