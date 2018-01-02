import CareKit
import ResearchKit

struct RestingHeartRate: Assessment {

    let activityType: ActivityType = .restingHeartRate
    let unit = HKUnit(from: "count/min")
    let quantityType: HKQuantityType = {
        var quantityTypeId: HKQuantityTypeIdentifier
        if #available(iOS 11.0, *) {
            quantityTypeId = .restingHeartRate
        } else {
            quantityTypeId = .heartRate
        }
        return HKQuantityType.quantityType(forIdentifier: quantityTypeId)!
    }()

    var associatedEvent: OCKCarePlanEvent?

    var carePlanActivity: OCKCarePlanActivity {
        let startDate = DateComponents(year: 2017, month: 12, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        let thresholds = [
            OCKCarePlanThreshold.numericThreshold(withValue: 48, type: .numericLessThanOrEqual, upperValue: nil, title: "Too low"),
            OCKCarePlanThreshold.numericThreshold(withValue: 49, type: .numericRangeInclusive, upperValue: 54, title: "Athlete"),
            OCKCarePlanThreshold.numericThreshold(withValue: 55, type: .numericRangeInclusive, upperValue: 61, title: "Excellent"),
            OCKCarePlanThreshold.numericThreshold(withValue: 62, type: .numericRangeInclusive, upperValue: 65, title: "Good"),
            OCKCarePlanThreshold.numericThreshold(withValue: 66, type: .numericRangeInclusive, upperValue: 70, title: "Above Average"),
            OCKCarePlanThreshold.numericThreshold(withValue: 71, type: .numericRangeInclusive, upperValue: 74, title: "Average"),
            OCKCarePlanThreshold.numericThreshold(withValue: 75, type: .numericRangeInclusive, upperValue: 81, title: "Below Average"),
            OCKCarePlanThreshold.numericThreshold(withValue: 82, type: .numericGreaterThanOrEqual, upperValue: nil, title: "Poor")
            ]

        let title = "Resting Heart Rate"
        let summary = "After 15 minutes of rest"

        let activity = OCKCarePlanActivity.assessment(withIdentifier: activityType.rawValue,
                                                      groupIdentifier: "Assessment",
                                                      title: title,
                                                      text: summary,
                                                      tintColor: .red,
                                                      resultResettable: false,
                                                      schedule: schedule,
                                                      userInfo: nil,
                                                      thresholds: [thresholds],
                                                      optional: false)
        return activity
    }

    var task: ORKTask {
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .integer)

        let title = "Enter your resting heart rate"
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: title, answer: answerFormat)
        questionStep.isOptional = false

        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        return task
    }
}

extension RestingHeartRate: HealthSampleBuilder {
    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample {
        guard let firstResult = result.firstResult as? ORKStepResult,
            let stepResult = firstResult.results?.first
            else { fatalError("Unexpected task results") }

        guard let hrResult = stepResult as? ORKNumericQuestionResult,
            let pressureAnswer = hrResult.numericAnswer
            else { fatalError("Unable to determine result answer") }

        let quantity = HKQuantity(unit: unit, doubleValue: pressureAnswer.doubleValue)
        let now = Date()

        return HKQuantitySample(type: quantityType, quantity: quantity, start: now, end: now)
    }

    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample {
        guard let firstResult = result.firstResult as? ORKStepResult,
            let stepResult = firstResult.results?.first
            else { fatalError("Unexpected task results") }

        guard let hrResult = stepResult as? ORKNumericQuestionResult,
            let pressureAnswer = hrResult.numericAnswer
            else { fatalError("Unable to determine result answer") }

        let quantity = HKQuantity(unit: unit, doubleValue: pressureAnswer.doubleValue)
        let now = Date()

        return HKQuantitySample(type: quantityType, quantity: quantity, start: now, end: now)
    }

}
