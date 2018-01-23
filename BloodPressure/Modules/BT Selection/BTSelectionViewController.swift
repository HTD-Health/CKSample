//
//  BTSelectionViewController.swift
//  BloodPressure
//
//  Created by Aleksander Maj on 11/01/2018.
//  Copyright © 2018 Aleksander Maj. All rights reserved.
//

import UIKit

class BTSelectionViewController: UITableViewController {

    let viewModel: BTSelectionViewModel

    var numberOfSections: (() -> Int)?
    var numberOfRowsInSection: ((Int) -> Int)?
    var deviceAtIndexPath: ((IndexPath) -> PeripheralViewModel?)?
    var leftBarButtonItemHandler: (() -> Void)?
    var didSelectRowAtIndexPath: ((IndexPath) -> Void)?

    init(viewModel: BTSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        if let leftBarButtonTitle = viewModel.leftBarButtonItemTitle {
            let leftBarButtonItem = UIBarButtonItem(title: leftBarButtonTitle, style: .plain, target: self,
                                                    action: #selector(leftBarButtonItemTapped))
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
        }

        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        tableView.register(UINib.init(nibName: "PeripheralTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        //tableView.register(PeripheralTableViewCell.self, forCellReuseIdentifier: "Cell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections?() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRowsInSection?(section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PeripheralTableViewCell,
            let device = deviceAtIndexPath?(indexPath) else { fatalError() }

        cell.viewModel = PeripheralTableViewCell.ViewModel(peripheral: device)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath?(indexPath)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension BTSelectionViewController {
    @objc func leftBarButtonItemTapped() {
        leftBarButtonItemHandler?()
    }
}
