require 'httparty'

class DataSetReader
    LINK_TO_DATA = 'http://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data'
    DATA_LINE_REGEXP = /(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/


    public
    def initialize(default_weight = 1)
        @data_file = HTTParty.get(LINK_TO_DATA).body
        @default_weight = default_weight
    end

    def get_data
        results = {}
        @data_file.each_line.with_index do |line, property_id|
            crim, zn, indus, chas, nox, rm, age, dis, rad, tax, ptratio, b, lstat, medv = DATA_LINE_REGEXP.match(line.scrub).captures
            results[property_id] = {
                property_value: medv.to_f,
                property_informations: {
                    crim: { value: crim.to_f, weight: @default_weight },
                    zn: { value: zn.to_f, weight: @default_weight },
                    indus: { value: indus.to_f, weight: @default_weight },
                    chas: { value: chas.to_f, weight: @default_weight },
                    nox: { value: nox.to_f, weight: @default_weight },
                    rm: { value: rm.to_f, weight: @default_weight },
                    age: { value: age.to_f, weight: @default_weight },
                    dis: { value: dis.to_f, weight: @default_weight },
                    rad: { value: rad.to_f, weight: @default_weight },
                    tax: { value: tax.to_f, weight: @default_weight },
                    pratio: { value: ptratio.to_f, weight: @default_weight },
                    b: { value: b.to_f, weight: @default_weight },
                    lstat: { value: lstat.to_f, weight: @default_weight }}}
        end

        results
    end
end
