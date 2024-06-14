const express = require('express')
const multer = require('multer')
const path = require('path')


class UploadController{
    //Konfigurasi Storage
    static fileStorage(folderName){
        return multer.diskStorage({
            destination: (req, file, cb) => {
                cb(null, `images/${folderName}`); //Direktori Penyimpanan
            },
            filename: (req, file, cb) => {
                const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
                cb(null, uniqueSuffix + path.extname(file.originalname)); //File Name
            }
        })
    }



    static fileFilter(req, file, cb) {
        if (    file.mimetype === 'image/png' ||
                file.mimetype === 'image/jpg' ||
                file.mimetype === 'image/jpeg' 
        ) {
            cb(null, true)
        } else {
            cb(null, false)
        }
    }

        static upload(folderName) {
        const storage = UploadController.fileStorage(folderName)
        return multer({ storage: storage, fileFilter: UploadController.fileFilter }).single('image')
    }
}

module.exports = UploadController;