require_relative 'knn'
require_relative 'data_set_reader'
require_relative 'property_info_builder'
require_relative 'euclidean_distance'
require_relative 'weight_calculator'

class WelcomeController < ApplicationController
    @@value = 0
    def index
    end

    def update
        needed_params = params.to_unsafe_h.map { |key, value| [key.to_sym, value.to_f] }
        needed_params = needed_params.reject { |key, value| !PropertyInfoBuilder.new.get.keys.include? key }
        @@value = generate_result(needed_params)
        redirect_to "/good"
    end

    def good
        @estimated_value = @@value
    end

    def generate_result(form_output)
        data_set = DataSetReader.new.get_data
        weights = get_default_weights
        knn = Knn.new(data_set: data_set,
                      weights: weights,
                      distance_calculator: EuclideanDistance.new,
                      weight_calculator: WeightCalculator.new)
        convert_output_to_proper_value(
            knn.calculate_property_value(property_info: form_output.to_h,
                                         nn: 3))
    end

    def convert_output_to_proper_value(value)
        (value * 1000).round(2)
    end

    def get_default_weights()
         pib = PropertyInfoBuilder.new
         pib.crim = 0.17770241038113407
         pib.zn = 0.0
         pib.indus = 0.9242785276130268
         pib.nox = 0.37260111122359174
         pib.rm = 1.4534492426904995
         pib.age = 0
         pib.dis = 1.1755265093394607
         pib.rad = 0.34161334708054625
         pib.tax = 0
         pib.pratio = 2.7755575615628914e-17
         pib.b = 0
         pib.lstat = 0.6585124866850744
         pib.get
    end
end
