const express       = require('express')
const bodyparser    = require('body-parser')
const Routers       = require('./routes/index')
const { sequelize } = require('./models')


const app = express();
const PORT = process.env.PORT || 4000;

app.use(bodyparser.json());
app.use(bodyparser.urlencoded({ extended: true }));

//Routes
app.use('/', Routers)

//static folder for serving images
app.use('/images', express.static('images'))

//Test Database connection
sequelize.authenticate()
    .then(() => {
        console.log('Connection has been estabilished successfully.');
    })
    .catch(err => {
        console.error('Unable connect to database:', err);
    })


app.listen(PORT, () => {
    console.log(`Server is running on ${PORT}`);
})

