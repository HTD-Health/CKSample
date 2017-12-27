import CareKit

struct RestingHeartRate {

    var carePlanActivity: OCKCarePlanActivity {
        let identifier = "RestingHeartRate"
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
}
