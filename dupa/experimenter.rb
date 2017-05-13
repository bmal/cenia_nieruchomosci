require_relative 'cross_validation'

class Experimenter
    def initialize(data_set, knn_creator, number_of_folds: 5)
        @folds = CrossValidation.new(data_set, number_of_folds)
        @knn_creator = knn_creator
    end

    def calculate_error(weights, nn = 5)
        results = {}
        @folds.each.with_index do |fold_data, fold_number|
            fold_results = calculate_fold_results(fold_data, weights, nn)
            results[fold_number] = fold_results
        end

        get_error(results)
    end

    private
    def calculate_fold_results(fold_data, weights, nn)
        training_set = fold_data[:training_set]
        testing_set = fold_data[:testing_set]

        results = {}
        knn = @knn_creator.call(training_set, weights)
        testing_set.each do |property_id, property_attributes|
            results[property_id] = {
                expected_result: property_attributes[:property_value],
                result: knn.calculate_property_value(property_info: property_attributes[:property_informations], nn: nn)}
        end

        results
    end

    def get_error(results)
        sum_of_errors = results.inject(0) do |sum, (_, fold_result)|
            sum + fold_result.inject(0) do |fold_sum, (_, property_result)|
                fold_sum + (property_result[:expected_result] - property_result[:result])**2
            end
        end

        number_of_predictions = results.inject(0) do |sum, (_, fold_result)|
            sum + fold_result.size
        end

        Math.sqrt(sum_of_errors / number_of_predictions.to_f)
    end
end
