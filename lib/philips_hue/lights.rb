module PhilipsHue
  class Lights
    include Enumerable
    extend Forwardable

    def_delegators :lights, :<<, :[], :[]=, :last, :first, :each

    attr_reader :lights

    def initialize(base_uri, lights_data=[])
      @resource_uri = base_uri + "/lights"
      @lights = []

      lights_data.each { |id, light| add_light(id, light) }
    end

    def find(id)
      @lights.find { |l| l.id == id.to_s }
    end

    private

    attr_reader :resource_uri

    def add_light(id, light_data)
      self << Light.new(resource_uri, id, light_data).tap do |light|
        define_singleton_method(light.underscored_name) { light }
      end
    end
  end
end
