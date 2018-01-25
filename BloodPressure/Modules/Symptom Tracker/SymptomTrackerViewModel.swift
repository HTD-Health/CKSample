import CareKit

class SymptomTrackerViewModel: NSObject, OCKSymptomTrackerViewControllerDelegate, ViewModelType {

    typealias Coordinator = SymptomTrackerCoordinator

    let coordinator: Coordinator
    private let activityManager: ActivityManager

    init(activityManager: ActivityManager, coordinator: Coordinator) {
        self.activityManager = activityManager
        self.coordinator = coordinator
        super.init()
    }

    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController,
                                      didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        print(String(describing: assessmentEvent))

        guard let activityType = ActivityType(rawValue: assessmentEvent.activity.identifier),
            var assessment = activityManager.activityWithType(activityType) as? Assessment
            else { return }

        assessment.associatedEvent = assessmentEvent

        coordinator.didSelectAssessment(assessment)
    }
}
