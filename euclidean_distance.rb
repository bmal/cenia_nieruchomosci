class EuclideanDistance
    def calculate_distance(property, other_property, weights)
        Math.sqrt(weights.inject(0) do |sum, (attribute_name, attribute_weight)|
            sum + attribute_weight * (property[attribute_name] - other_property[attribute_name])**2
        end)
    end
end
