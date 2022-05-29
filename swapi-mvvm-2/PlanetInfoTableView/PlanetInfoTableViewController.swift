//
//  TestTableViewController.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import UIKit

class PlanetInfoTableViewController: UITableViewController, PlanetInfoViewModelDelegate {
    
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    var viewModel: PlanetInfoViewModel? 

    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewModel?.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Keys.detailViewInfoCell)
        title = viewModel?.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel?.films.count ?? 0
        case 2:
            return viewModel?.residentNames.count ?? 0
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.detailViewInfoCell, for: indexPath)
        var config = cell.defaultContentConfiguration()
        switch indexPath.section {
        case 0:
            config.text = viewModel?.description
        case 1:
            config.text = viewModel?.filmName(for: indexPath.row)
        case 2:
            config.text = viewModel?.residentNames[indexPath.row]
        default:
            config.text = "test"
        }
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Films"
        case 2:
            return "Residents"
        default:
            return "no"
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: tableView.deselectRow(at: indexPath, animated: false)
        case 1: print("selected")
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            print("default")
        }
    }

}
