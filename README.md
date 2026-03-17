# BMI Calculator API

Calculate Body Mass Index from weight and height.

## Endpoint

### GET `/calculate`

**Parameters:**
- `weight` (required): Weight in kg (number)
- `height` (required): Height in meters (number)

**Example Request:**
```
http://localhost:3002/calculate?weight=70&height=1.75
```

**Example Response:**
```json
{
  "weight": 70,
  "height": 1.75,
  "bmi": 22.9,
  "category": "Normal"
}
```
