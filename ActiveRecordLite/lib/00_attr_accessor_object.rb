class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
      define_method(name) do
        instance_variable_get("@#{name}")
        # instance_variable_get(:@name) how come this defines getter? 
        # but doesn't get from associated ivars?
      end
    end

    names.each do |name|
      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end
    end

  end
end
