import ResearchKit

class AssessmentTaskViewController: ORKTaskViewController, ViewControllerType {

    typealias ViewModel = AssessmentTaskViewModel
    
    let viewModel: ViewModel

    init(viewModel: ViewModel, task: ORKTask?, taskRun: UUID?) {
        self.viewModel = viewModel
        super.init(task: task, taskRun: taskRun)
        self.delegate = viewModel
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
