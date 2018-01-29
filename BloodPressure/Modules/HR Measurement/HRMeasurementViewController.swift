import UIKit
import RxSwift
import RxCocoa

class HRMeasurementViewController: UIViewController, ViewControllerType {

    typealias ViewModel = HRMeasurementViewModel

    @IBOutlet weak var hrValueLabel: UILabel!
    @IBOutlet weak var averageHRLabel: UILabel!
    @IBOutlet weak var deviceStatusLabel: UILabel!
    @IBOutlet weak var deviceButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!

    let viewModel: HRMeasurementViewModel
    let disposeBag = DisposeBag()

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

        viewModel.updateDeviceStatusHandler = { [unowned self] (status, name) in
            self.deviceStatusLabel.text = status
            self.deviceButton.setTitle(name, for: .normal)
        }

        viewModel.updateMeasurementStatusHandler = { [unowned self] (isRecording) in
            self.actionButton.setTitle(isRecording ? "Finish" : "Start", for: .normal)
        }

        let hrValueDriver = viewModel.heartRateText.asDriver()
        let averageHrValueDriver = viewModel.averageHeartRateText.asDriver()

        hrValueDriver.drive(hrValueLabel.rx.text).disposed(by: disposeBag)
        averageHrValueDriver.drive(averageHRLabel.rx.text).disposed(by: disposeBag)
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    @IBAction func doneTapped(_ sender: Any) {
        viewModel.actionButtonTapped()
    }

    @IBAction func deviceButtonTapped(_ sender: UIButton) {
        viewModel.deviceButtonTapped()
    }

    private func updateMeasurementStatus(status: HRMeasurementStatus) {
        switch status {
        case .disconnected:
            actionButton.setTitle("Start", for: .normal)
            actionButton.isEnabled = false
        case .connected(_):
            actionButton.setTitle("Start", for: .normal)
            actionButton.isEnabled = true
        case .recording(_, _):
            actionButton.setTitle("Finish", for: .normal)
            actionButton.isEnabled = true
        }
    }
}
