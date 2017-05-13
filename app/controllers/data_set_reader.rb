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
                    crim: crim.to_f,
                    zn: zn.to_f,
                    indus: indus.to_f,
                    chas: chas.to_f,
                    nox: nox.to_f,
                    rm: rm.to_f,
                    age: age.to_f,
                    dis: dis.to_f,
                    rad: rad.to_f,
                    tax: tax.to_f,
                    pratio: ptratio.to_f,
                    b: b.to_f,
                    lstat: lstat.to_f}}
        end

        results
    end
end
