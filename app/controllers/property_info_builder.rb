class PropertyInfoBuilder
    attr_writer :crim, :zn, :indus, :nox, :rm, :age, :dis, :rad, :tax, :pratio, :b, :lstat

    def initialize(default_value_generator = Proc.new { 0 })
        @default_value_generator = default_value_generator
    end

    def get
        {
            crim: @crim || @default_value_generator.call,
            zn: @zn || @default_value_generator.call,
            indus: @indus || @default_value_generator.call,
            chas: @chas || @default_value_generator.call,
            nox: @nox || @default_value_generator.call,
            rm: @rm || @default_value_generator.call,
            age: @age || @default_value_generator.call,
            dis: @dis || @default_value_generator.call,
            rad: @rad || @default_value_generator.call,
            tax: @tax || @default_value_generator.call,
            pratio: @pratio || @default_value_generator.call,
            b: @b || @default_value_generator.call,
            lstat: @lstat || @default_value_generator.call }
    end
end
