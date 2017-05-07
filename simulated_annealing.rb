require_relative 'experimenter'
require_relative 'property_info_builder'
require_relative 'euclidean_distance'
require_relative 'weight_calculators'
require_relative 'data_set_reader'
require_relative 'knn'

class SimulatedAnnealing
    SEED = 13
    MINIMUM_NEIGHBOURS = 3

    def initialize(temperature: 10000.0, cooling_rate: 0.95, step: 0.1, neighbours_step: 3)
        @temperature = temperature
        @cooling_rate = cooling_rate
        @step = step
        @neighbours_step = neighbours_step
    end

    def optimize_weights(experimenter)
        weights = get_random_weights
        n = get_random_n

        smallest_error = 999
        best_weights = weights
        best_n = MINIMUM_NEIGHBOURS

        current_temperature = @temperature
        while hot? current_temperature
            if modify_weights? weights.keys
                new_weights = calculate_weights_with_one_attribute_changed(weights)
                new_n = n
            else
                new_weights = weights
                new_n = calculate_new_n(n)
            end

            error_with_old_weights = experimenter.calculate_error(weights, n)
            error_with_new_weights = experimenter.calculate_error(new_weights, new_n)

            probability_of_choosing_worse_weights = Math.exp(70*(-error_with_new_weights - error_with_old_weights)/current_temperature)
            p probability_of_choosing_worse_weights

            if(error_with_old_weights > error_with_new_weights || rand < probability_of_choosing_worse_weights)
                weights = new_weights
                n = new_n

                if error_with_new_weights < smallest_error
                    smallest_error = error_with_new_weights
                    best_weights = new_weights
                    best_n = new_n
                end
            end

            current_temperature *= @cooling_rate
            puts "temperature: #{current_temperature}"
            puts "new_error: #{error_with_new_weights}"
            puts "new_n: #{new_n}"
            puts ""
        end

        {weights: best_weights,
         error: smallest_error,
         n: best_n}
    end

    private
    def get_random_weights
        random = Random.new(SEED)
        PropertyInfoBuilder.new(Proc.new { random.rand(0.0..1.0) }).get
    end

    def get_random_n
        random = Random.new(SEED)
        random.rand(3*MINIMUM_NEIGHBOURS..6*MINIMUM_NEIGHBOURS)
    end

    def hot?(current_temperature)
        current_temperature > 0.005
    end

    def modify_weights?(attributes)
        attributes << "n"
        if attributes.sample != "n"
            true
        else
            false
        end
    end

    def calculate_weights_with_one_attribute_changed(weights)
        attr_to_modification = get_random_attribute(weights.keys)
        new_weights = weights.dup
        new_weights[attr_to_modification] = calculate_new_value_of_attribute(weights[attr_to_modification])

        new_weights
    end

    def calculate_new_n(n)
        n += [-@neighbours_step, @neighbours_step].sample
        if n < MINIMUM_NEIGHBOURS
            n = MINIMUM_NEIGHBOURS
        end

        n 
    end

    def get_random_attribute(attributes)
        attributes.sample
    end

    def calculate_new_value_of_attribute(value)
        value += [-@step, @step].sample
        if value < 0
            value = 0
        end

        value
    end
end

data_set = DataSetReader.new.get_data
sa = SimulatedAnnealing.new
results = {}

ex = Experimenter.new(data_set, Proc.new do |fold_data, weights|
    Knn.new(data_set: fold_data, weights: weights, distance_calculator: EuclideanDistance.new, weight_calculator: ReverseFunctionCalculator.new)
end)
puts "ReverseFunctionCalculator"
results[:ReverseFunctionCalculator] = sa.optimize_weights(ex)

ex = Experimenter.new(data_set, Proc.new do |fold_data, weights|
    Knn.new(data_set: fold_data, weights: weights, distance_calculator: EuclideanDistance.new, weight_calculator: RandomGaussianCalculator.new)
end)
puts "RandomGaussianCalculator"
results[:RandomGaussianCalculator] = sa.optimize_weights(ex)

ex = Experimenter.new(data_set, Proc.new do |fold_data, weights|
    Knn.new(data_set: fold_data, weights: weights, distance_calculator: EuclideanDistance.new, weight_calculator: SubtractionFunctionCalculator.new(50))
end)
puts "SubtractionFunctionCalculator"
results[:SubtractionFunctionCalculator] = sa.optimize_weights(ex)

puts "WYNIKI:"
p results
