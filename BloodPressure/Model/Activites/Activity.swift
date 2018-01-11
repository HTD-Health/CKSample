import CareKit
import ResearchKit

protocol Activity {
    var activityType: ActivityType { get }
    var carePlanActivity: OCKCarePlanActivity { get }
}

protocol Assessment: Activity {
    var task: ORKTask { get }
    var associatedEvent: OCKCarePlanEvent? { get set }
}

enum ActivityType: String {
    case restingHeartRate
    case systolicBloodPressure
}

protocol HealthSampleBuilder {
    var quantityType: HKQuantityType { get }
    var unit: HKUnit { get}
    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample
}

extension Assessment {
    func buildResultForTaskResult(_ taskResult: ORKTaskResult) -> OCKCarePlanEventResult {
        // Get the first result for the first step of the task result.
        guard let firstResult = taskResult.firstResult as? ORKStepResult,
            let stepResult = firstResult.results?.first else { fatalError("Unexepected task results") }

        // Determine what type of result should be saved.
        if let scaleResult = stepResult as? ORKScaleQuestionResult, let answer = scaleResult.scaleAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: "of 10", userInfo: nil, values: [answer])
        } else if let numericResult = stepResult as? ORKNumericQuestionResult, let answer = numericResult.numericAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: numericResult.unit!, userInfo: nil, values: [answer])
        }

        fatalError("Unexpected task result type")
    }
}
