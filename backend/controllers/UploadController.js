// UploadController.js
const multer = require('multer');
const path = require('path');

class UploadController {
  static fileStorage(folderName) {
    return multer.diskStorage({
      destination: (req, file, cb) => {
        cb(null, path.join(__dirname, `../images/${folderName}`)); // Direktori Penyimpanan
      },
      filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname)); // Nama File
      }
    });
  }

  static fileFilter(req, file, cb) {
    const allowedTypes = ['image/png', 'image/jpg', 'image/jpeg'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type. Only jpg, png, and jpeg are allowed.'));
    }
  }

  static upload(folderName, fileFilter) {
    const storage = UploadController.fileStorage(folderName);
    return multer({
      storage: storage,
      fileFilter: fileFilter,
      limits: { fileSize: 5 * 1024 * 1024 } // Limit file size to 5MB
    }).single('urlImage'); // Nama field harus 'urlImage'
  }
}

 

module.exports = UploadController;