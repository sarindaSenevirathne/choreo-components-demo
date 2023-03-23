const express = require('express');
const request = require('request');

const apiKey = '9d723b8f61b1647d8f9369bcf33c64a5';
const apiSecret = '964fbb2073d53f3d2ab9a7fb3198a9e3';
const shopName = 'hashenstore';
const scope = 'read_orders'; // Replace with the scope(s) you need

const authUrl = `https://${shopName}.myshopify.com/admin/oauth/authorize?client_id=${apiKey}&scope=${scope}&redirect_uri=http://localhost:3000/callback`;

const app = express();

// Redirect the user to the authorization URL
// After the user grants permission, Shopify will redirect back to the specified redirect URI with a temporary code parameter
app.get('/auth', (req, res) => {
  res.redirect(authUrl);
});

// Handle the callback from Shopify after the user grants permission
app.get('/pi/shopify/redirect', (req, res) => {
  const code = req.query.code;

  // Exchange the temporary code for a permanent access token
  request.post({
    url: `https://${shopName}.myshopify.com/admin/oauth/access_token`,
    form: {
      code: code,
      client_id: apiKey,
      client_secret: apiSecret
    }
  }, (err, response, body) => {
    if (err) {
      console.error(err);
      res.status(500).send('Failed to obtain access token');
      return;
    }

    const accessToken = JSON.parse(body).access_token;
   // const accessToken = JSON.parse(body).access_token;
    console.log(`Access token $$$$$$$$$$: ${accessToken}`);
    // Use the access token to make API requests
    // ...
  });
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
