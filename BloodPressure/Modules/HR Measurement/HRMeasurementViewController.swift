import UIKit

class HRMeasurementViewController: UIViewController, ViewControllerType {

    typealias ViewModel = HRMeasurementViewModel

    @IBOutlet weak var hrValueLabel: UILabel!
    @IBOutlet weak var averageHRLabel: UILabel!

    let viewModel: HRMeasurementViewModel

    init(viewModel: HRMeasurementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heart rate"
        viewModel.viewDidLoad()
    }

    @IBAction func doneTapped(_ sender: Any) {
        viewModel.doneTapped()
    }
}

extension HRMeasurementViewController {
    func hrValueDidUpdate(hrValue: Int) {
        hrValueLabel.text = "\(hrValue)"
    }

    func hrAverageValueDidUpdate(averageValue: Int) {
        averageHRLabel.text = "Average: \(averageValue)"
    }
}
