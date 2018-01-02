import ResearchKit
import CareKit

class AssessmentTaskViewModel: NSObject {
    private let coordinator: AssessmentTaskCoordinator
    private let assessment: Assessment
    private let storeManager: CarePlanStoreManager

    init(coordinator: AssessmentTaskCoordinator, assessment: Assessment, storeManager: CarePlanStoreManager) {
        self.coordinator = coordinator
        self.assessment = assessment
        self.storeManager = storeManager
        super.init()
    }
}

extension AssessmentTaskViewModel: ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        defer {
            coordinator.dismiss()
        }
        let result = taskViewController.result
        let carePlanResult = assessment.buildResultForTaskResult(result)

        guard let event = assessment.associatedEvent else { return }

        if let healthSampleBuilder = assessment as? HealthSampleBuilder {
            let sample = healthSampleBuilder.buildSampleWithTaskResult(result)
            let sampleTypes: Set<HKSampleType> = [sample.sampleType]

            let healthStore = HKHealthStore()
            healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes, completion: { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                    return
                }

                healthStore.save(sample, withCompletion: { (success, _) in
                    if success {
                        let healthKitAssociatedResult = OCKCarePlanEventResult(
                            quantitySample: sample,
                            quantityStringFormatter: nil,
                            display: healthSampleBuilder.unit,
                            displayUnitStringKey: healthSampleBuilder.unit.localizedUnitString(),
                            userInfo: nil)
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: healthKitAssociatedResult)
                    } else {
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)

                    }
                })
            })
        } else {
            self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
        }
    }

    fileprivate func completeEvent(_ event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
        store.update(event, with: result, state: .completed) { success, _, error in
            if !success {
                print(error!.localizedDescription)
            }
        }
    }

}
