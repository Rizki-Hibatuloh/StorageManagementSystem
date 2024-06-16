const { User }  = require('../models')
const bcrypt    = require('bcryptjs')
const jwt       = require('jsonwebtoken')
const { where } = require('sequelize')

class UserController {
    async register(req, res) {
    try { 
        const { username, password, image } = req.body;

        if (!username || !password) {
            return res.status(400).json({ err: 'All fields are required' });
        }

        const existingUser = await User.findOne({ where: { username } });
        if (existingUser) {
            return res.status(400).json({ err: 'Username is already taken' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = await User.create({ username, password: hashedPassword, image });
        res.status(201).json({ message: 'Registration successful', user: newUser });
    } catch (err) {
        res.status(500).json({ err: 'Failed to register' });
    }
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
        res.json({ status: 'Login Successful', token });

    } catch (err) {
        res.status(500).json({ err: 'Failed to login' });
    }
}

    async uploadProfile(req, res) {
        try { 
            console.log(`Received  userId:`,req.body.userId);
            console.log(`Uploading image to:`, req.file);
            if (!req.file) {
                return res.status(400).json({ err : 'No file Uploaded'})
            }

            const { userId } = req.body;
            const imageUrl = `/images/profiles${req.file.filename}`;

            if (isNaN(userId)) {
                return res.status(400).json({ err: 'Invalid UserId'})
            }

            const user = await User.findByPk(userId);
            if (!user) {
                return res.status(404).json({ err : 'User not found'})
            }

            await user.update({ image: imageUrl });
            console.log('Profile image updated in database:', imageUrl);
            res.status(200).json({ message: "Profile Image has been uploaded Successfully" })
            
        } catch (err) {
            console.error('Error updating profile image:', err);
            res.status(500).json({ err : 'Failed to uploaded profile Image'})
        }
    }
}

module.exports = UserController;