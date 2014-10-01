class CommerceUnits::BaseFactory
  class << self
    def belongs_to(thing)
      new.belongs_to(thing)
    end

    def mock
      new.create
    end
  end
  def create
    _creator.create! attributes
  end
  alias_method :mock, :create

  def attributes
    throw :NotImplemeneted
  end

  private

  def _creator
    self.class.parent.const_get _factory_output_class
  end

  def _factory_output_class
    self.class.to_s.split("::").last.underscore.split("_").head.join("_").camelcase
  end

end