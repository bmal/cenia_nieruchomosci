require_relative 'data_set_reader'

class Knn
    def initialize(data_set:, distance_calculator:, weight_calculator:)
        @data_set = data_set
        @distance_calculator = distance_calculator
        @weight_calculator = weight_calculator
    end

    def calculate_property_value(property_info:, nn:)
        nearest_neighbours = calculate_nearest_neighbours(property_info).take(nn)
    end

    private
    def calculate_nearest_neighbours(property_info)
    end
end

data_set = DataSetReader.new.get_data
