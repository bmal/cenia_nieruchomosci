class PropertyInfoBuilder
    attr_writer :crim, :zn, :indus, :nox, :rm, :age, :dis, :rad, :tax, :pratio, :b, :lstat

    def initialize(default_value = 0)
        @default_value = default_value
    end

    def get
        {
            crim: @crim || @default_value,
            zn: @zn || @default_value,
            indus: @indus || @default_value,
            chas: @chas || @default_value,
            nox: @nox || @default_value,
            rm: @rm || @default_value,
            age: @age || @default_value,
            dis: @dis || @default_value,
            rad: @rad || @default_value,
            tax: @tax || @default_value,
            pratio: @pratio || @default_value,
            b: @b || @default_value,
            lstat: @lstat || @default_value }
    end
end
