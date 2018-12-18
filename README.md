# ATM JSON API

ATM API implementation

### Installation
```sh
bundle intstall
rails db:setup
rails s
```
### API interaction
API supports 2 endpoints:
* `atm/replenish` (for ATM refilling)
* `atm/withdraw` (for withdrawal)

They are avaialble through `POST` requests

### `replenish` method

* endpoint: `atm/replenish`
* method: `POST`
* Content-Type: `application/json`
* params example:
```json
{
  "atm": {
    "banknotes": [
      { "face_value": 10, "quantity": 2},
      { "face_value": 25, "quantity": 1},
      { "face_value": 5, "quantity": 4}
    ]
  }
}
```
* parameter requirements:
    * `params[atm][banknotes][][face_value]` - required, one of set [1, 2, 5, 10, 25, 50]
    * `params[atm][banknotes][][quantity]` - required, integer, greater than zero
* curl request example:
```sh
curl -d '{"atm": { "banknotes": [ { "face_value": 10, "quantity": 2 }, { "face_value": 25, "quantity": 3 } ] }}' \
-H "Content-Type:application/json" -X POST http://localhost:3000/atm/replenish
```
* success response example:
```json
{ "total_sum": 1175 }
```
* error response example:
```json
{
  "errors": {
    "0": {
      "quantity": [
        "must be greater than 0"
      ]
    }
  }
}
```

### `withdraw` method

* endpoint: `atm/withdraw`
* method: `POST`
* Content-Type: `application/json`
* params example:
```json
{ "atm": { "amount": 135 } }
```
* parameter requirements:
    * `params[atm][amount]` - required, integer, greater than zero
* curl request example:
```sh
curl -d '{"atm": { "amount": 135 }}' \
-H "Content-Type:application/json" -X POST http://localhost:3000/atm/withdraw
```
* success response example:
```json
{ "banknotes": { "50": 2, "25": 1, "10": 1} }
```
* error response example:
```json
{ "error":"Insufficient Funds" }
```
### Running tests
```sh
rspec
```
### Used gems
* Trailblazer
* Reform
* Dry-validations
* Rspec
