class CommerceUnits::TimeFactory
  class << self
    def everything
      [day, week, year, decade, century]
    end
    def day
      _cm unit_name:"day",
        multiply_constant: 1.0
    end
    def week
      _cm unit_name: "week",
        multiply_constant: 7
    end
    def year
      _cm unit_name: "year",
        multiply_constant: 365.25
    end
    def decade
      _cm unit_name: "decade",
        multiply_constant: 3652.5
    end
    def century
      _cm unit_name: "century",
        multiply_constant: 36525
    end
    private
    def _cm(hash)
      CommerceUnits::Dimension.find_or_create_and_consider_making_primary! hash.merge root_dimension: "time"
    end
  end
end