import CareKit
import ResearchKit

struct BloodPressure {

    let activityType = "BloodPressure"
    var carePlanActivity: OCKCarePlanActivity {
        let identifier = activityType
        let startDate = DateComponents(year: 2017, month: 12, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        let thresholds = [
            OCKCarePlanThreshold.numericThreshold(withValue: 90, type: .numericLessThanOrEqual, upperValue: nil, title: "Low"),
            OCKCarePlanThreshold.numericThreshold(withValue: 91, type: .numericRangeInclusive, upperValue: 120, title: "Ideal blood pressure"),
            OCKCarePlanThreshold.numericThreshold(withValue: 121, type: .numericRangeInclusive, upperValue: 140, title: "Pre-high blood pressure"),
            OCKCarePlanThreshold.numericThreshold(withValue: 141, type: .numericGreaterThanOrEqual, upperValue: nil, title: "High blood pressure")
        ]

        let title = "Systolic blood pressure"
        let summary = "Blood pressure"

        let activity = OCKCarePlanActivity.assessment(withIdentifier: identifier,
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
        let quantityType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let unit = HKUnit(from: "mmHg")
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .integer)

        let title = "Enter your systolic blood pressure"
        let questionStep = ORKQuestionStep(identifier: activityType, title: title, answer: answerFormat)
        questionStep.isOptional = false

        let task = ORKOrderedTask(identifier: activityType, steps: [questionStep])
        return task
    }
}

