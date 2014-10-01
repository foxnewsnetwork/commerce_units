# CommerceUnits

Another units library for Ruby which helps with maintaining consist mathematics. But unlike scientific (SI) units, where we're all agreed to things like 1000g = 1kg, 1 hour = 60 minutes, and whatnot, commerce_units makes no assumptions on what kinds of units there.

Instead, commerical units allows you to define your own conversion rates between different units and operations such as multiply and divide will automatically handle conversions and reductions while addition and subtraction will throw errors if inappropriately dimensioned values are added together.


## Installation

Add this line to your application's Gemfile:

    gem 'commerce_units'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install commerce_units

## Usage

### Step 1: generate the migration to create the dimensions
```shell
rails generate commerce_units
```
What?! This is unit library, yet you demand a database migration? What sort of stupid shit...

Well, the justification is that this is a commerce units library, and, in business, I have no idea what sort of units you might be using to quantify your transactions. In my case, I built this library originally to use for money per weight, and the dimension of money has all sorts of units (dollars, cents, rupies, RMB, yen, pound-sterling, etc.) which even change with time. 

If you think your business is measured in dollars per boxes, then it's up to you to declare dollars with a money dimension and boxes in some other root dimension.

### Step 2: seed the CommerceUnits::Dimension record with the units you'll need
Declare your units, here's an example
```ruby
CommerceUnits::Dimension.create! root_dimension: :money,
  unit_name: "dollar",
  multiply_constant: 1.0,
  unitary_role: :primary

CommerceUnits::Dimension.create! root_dimension: :money,
  unit_name: "cent",
  multiply_constant: 100.0 # 100 cents go into 1 us dollar

CommerceUnits::Dimension.create! root_dimension: :money,
  unit_name: "RMB",
  multiply_constant: 6.654 # 6.654 RMB go into 1 us dollar

CommerceUnits::Dimension.create! root_dimension: :money,
  unit_name: "euro",
  multiply_constant: 12000 # 12000 euros go into 1 us dollar because Yuropoor is poor

CommerceUnits::Dimension.create! root_dimension: :mass,
  unit_name: 'pound',
  multiply_constant: 1.0,
  unitary_role: :primary

CommerceUnits::Dimension.create! root_dimension: :mass,
  unit_name: 'ton',
  multiply_constant: 2000 # 2000 pounds go into 1 ton

CommerceUnits::Dimension.create! root_dimension: :mass,
  unit_name: 'landwhale',
  multiply_constant: 354 # 354 pounds go into 1 landwhale
```

### Step 3: Use
Here's an example
```ruby
dollar_per_pound = CommerceUnit::Value.from_params number: 1234, units: "dollar / pound"
dollar_per_pound.to_s # 1234 dollar / pound

euro_per_ton = CommerceUnit::Value.from_params number: 34, units: "euro / ton"
dollar_per_pound + euro_per_ton # 1234.00000... dollar / pound

dollar_per_landwhale_squared = CommerceUnit::Value.from_params number: 1, units: "dollar / landwhale / landwhale"
euro_per_ton + dollar_per_landwhale_squared # throws unit mismatch error

(euro_per_ton / dollar_per_pound ).unitless? # true

```
## Assumptions
If "mango" and "chair" are both declared as commerce units of the same dimension, then any amount of mangos can be converted to chairs by a constant multiplication. This necessarily means 0 mangos == 0 chairs

If you specify 0 as the multiply_constant, you'll eat a face full of DivideByZero errors.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/commerce_units/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
