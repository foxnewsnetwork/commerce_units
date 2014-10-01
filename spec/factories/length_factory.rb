class CommerceUnits::LengthFactory
  class << self
    def everything
      [centimeter, meter, kilometer, inch, foot, yard, mile]
    end
    def centimeter
      _cm unit_name:"centimeter",
        multiply_constant: 1.0
    end
    def meter
      _cm unit_name: 'meter',
        multiply_constant: 100
    end
    def kilometer
      _cm unit_name: 'kilometer',
        multiply_constant: 100000
    end
    def inch
      _cm unit_name: 'inch',
        multiply_constant: 2.54
    end
    def foot
      _cm unit_name: 'foot',
        multiply_constant: 30.48
    end
    def yard
      _cm unit_name: 'yard',
        multiply_constant: 91.44
    end
    def mile
      _cm unit_name: 'mile',
        multiply_constant: 160934
    end
    private
    def _cm(hash)
      CommerceUnits::Dimension.find_or_create_and_consider_making_primary! hash.merge root_dimension: "length"
    end
  end
end