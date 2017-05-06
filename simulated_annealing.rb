require_relative 'experimenter'
require_relative 'property_info_builder'
require_relative 'euclidean_distance'
require_relative 'weight_calculators'
require_relative 'data_set_reader'
require_relative 'knn'

class SimulatedAnnealing
    SEED = 13

    def initialize(temperature: 10000.0, cooling_rate: 0.95, step: 0.1)
        @temperature = temperature
        @cooling_rate = cooling_rate
        @step = step
    end

    def optimize_weights(experimenter)
        weights = get_random_weights
        smallest_error = 999

        while hot?
            new_weights = calculate_weights_with_one_attribute_changed(weights)

            error_with_old_weights = experimenter.calculate_error(weights)
            error_with_new_weights = experimenter.calculate_error(new_weights)

            probability_of_choosing_worse_weights = Math.exp((-error_with_new_weights - error_with_old_weights)/@temperature)

            if(error_with_old_weights > error_with_new_weights || rand < probability_of_choosing_worse_weights)
                weights = new_weights
                smallest_error = error_with_new_weights
            end

            @temperature *= @cooling_rate
            puts "error #{smallest_error}"
            puts "temperature #{@temperature}"
        end

        [weights, smallest_error]
    end

    private
    def get_random_weights
        random = Random.new(SEED)
        PropertyInfoBuilder.new(Proc.new { random.rand(0.0..1.0) }).get
    end

    def hot?
        @temperature > 0.1
    end

    def calculate_weights_with_one_attribute_changed(weights)
        attr_to_modification = get_random_attribute(weights.keys)
        new_weights = weights
        new_weights[attr_to_modification] = calculate_new_value_of_attribute(weights[attr_to_modification])

        new_weights
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
ex = Experimenter.new(data_set, Proc.new do |fold_data, weights|
    Knn.new(data_set: data_set, weights: weights, distance_calculator: EuclideanDistance.new, weight_calculator: ReverseFunctionCalculator.new)
end)

weights, error = SimulatedAnnealing.new.optimize_weights(ex)

p weights
p error
