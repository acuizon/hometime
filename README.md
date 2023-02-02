
# HOMETIME
Reservation process for different payloads

### Setup
- `git clone git@github.com:acuizon/hometime.git`
- using Ruby 2.7.3 and with rbenv
- install [rbenv](https://github.com/rbenv/rbenv#installation)
  - install the version `rbenv install 2.7.3`
  - on the app's root directory, set `rbenv local 2.7.3`
- run `bundle install`

### Database
- using MySQL
- run `bundle exec rake db:create && rake db:migrate`

### Test
- run `bundle exec rails test`

### Default Usage
- startup the server `bundle exec rails s`
- open a separate console tab, then send payload through curl:
```
curl -X POST http://localhost:3000/api/v1/reservations/create_update -H 'Content-Type: application/json' -d '{"reservation_code": "YYY12345678", "start_date": "2021-04-14", "end_date": "2021-04-18", "nights": 4, "guests": 4, "adults": 2, "children": 2, "infants": 0, "status": "accepted", "guest": {"first_name": "Wayne", "last_name": "Woodbridge", "phone": "639123456789", "email": "wayne_woodbridge@bnb.com"}, "currency": "AUD", "payout_price": "4200.00", "security_price": "500", "total_price": "4700.00"}'
```
- currently defined to handle 2 payload formats:
  - **AirbnbHost** (on `app/classes/airbnb_host.rb`) and **BookingHost** (on `app/classes/booking_host.rb`)
  - each defined hosts are included in the array of `PARTNERS` found on **Host** (on `app/classes/host.rb`)
 
### Additional
- to add another payload format
```
example

{
  "code": "RRRR54321",
  "status": "",
  "occupancy": {
    "start_date": "",
    "end_date": "",
    "nights": 0,
    "guests": 0,
    "adults": 0,
    "children": 0,
    "infants": 0,
  },
  "price": {
  "currency": "AUD",
  "payout": "",
    "security": "",
    "total": ""
  },
  "guest": {
    "name": {
      "first": "",
      "last": ""
    },
    "phone": "",
    "email": ""
  }
}
```

- need to create a new class ex: **RandomHost** (put it on `app/classes/random_host.rb`)
- define the `initialize` method and set the matchers (these are the paths to hash keys to dig on the payload that corresponds to the models (Guest, Reservation, etc.) attributes) 

```
def initialize(hsh)
  @name = "Random name"
  @payload = hsh

  @matchers = {
    guest: {
      email: [:guest, :email],
      firstname: [:guest, :name, :first],
      lastname: [:guest, :name, :last],
      phone: [:guest, :phone]
    },
    reservation: {
      code: [:code],
      status: [:status]
    },
    occupancy: {
      nights: [:occupancy, :nights],
      guests: [:occupancy, :guests],
      adults: [:occupancy, :adults],
      children: [:occupancy, :children],
      infants: [:occupancy, :infants],
      start_date: [:occupancy, :start_date],
      end_date: [:occupancy, :end_date]
    },
    price: {
      currency: [:price, :currency],
      payout_price: [:price, :payout],
      security_price: [:price, :security],
      total_price: [:price, :total]
    }
  }
end
```
  - then update the array of `PARTNERS` on `app/classes/host.rb` to include your new host ex: 
```
  {
    class: "RandomHost", # this should match the class name you created
    dig_code: [:code] , # this refers to the path of hash keys to get to the code
    code_indicators: ["rrrr"] # this refers to initial set of strings on the reservation code that it will try to match
  }
```
  - you can restart the server and try curling with your new payload