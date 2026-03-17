const express = require('express');
const app = express();

app.get('/calculate', (req, res) => {
  const { weight, height } = req.query;
  if (!weight || !height) return res.status(400).json({ error: 'Missing weight or height' });
  
  const w = parseFloat(weight);
  const h = parseFloat(height);
  if (isNaN(w) || isNaN(h)) return res.status(400).json({ error: 'Weight and height must be numbers' });
  
  const bmi = w / (h * h);
  let category;
  if (bmi < 18.5) category = 'Underweight';
  else if (bmi < 25) category = 'Normal';
  else if (bmi < 30) category = 'Overweight';
  else category = 'Obese';
  
  res.json({ weight: w, height: h, bmi: Math.round(bmi * 10) / 10, category });
});

app.listen(3002, () => console.log('BMI Calculator API on port 3002'));
