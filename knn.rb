require_relative 'data_set_reader'
require_relative 'property_info_builder'
require_relative 'euclidean_distance'

class Knn
    def initialize(data_set:, weights:, distance_calculator:, weight_calculator:)
        @data_set = data_set
        @weights = weights
        @distance_calculator = distance_calculator
        @weight_calculator = weight_calculator
    end

    def calculate_property_value(property_info:, nn:)
        nearest_neighbours = calculate_nearest_neighbours(property_info).take(nn)
        nearest_neighbours_with_weights = calculate_nearest_neighbours_weights(nearest_neighbours)

        numerator = nearest_neighbours_with_weights.inject(0) do |sum, (property_id, weight)|
            sum + @data_set[property_id][:property_value] * weight
        end

        denominator = nearest_neighbours_with_weights.inject(0) do |sum, (_, weight)|
            sum + weight
        end

        numerator / denominator
    end

    private
    def calculate_nearest_neighbours(property_info)
        property_id_and_distance = @data_set.map do |property_id, other_property_attributes|
            other_property_info = other_property_attributes[:property_informations]
            [property_id, @distance_calculator.calculate_distance(property_info, other_property_info, @weights)]
        end

        property_id_and_distance.sort_by {|_, distance| distance}
    end

    def calculate_nearest_neighbours_weights(nearest_neighbours)
        nearest_neighbours.map do |property_id, property_distance|
            [property_id, @weight_calculator.calculate_weight(property_distance)]
        end
    end
end


weights = PropertyInfoBuilder.new(1).get
data_set = DataSetReader.new.get_data

property = PropertyInfoBuilder.new
property.crim = 0.21

knn = Knn.new(data_set: data_set, weights: weights, distance_calculator: EuclideanDistance.new, weight_calculator: Object.new)
p knn.calculate_property_value(property_info: property.get, nn: 5)
