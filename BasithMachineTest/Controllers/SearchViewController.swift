//
//  ViewController.swift
//  BasithMachineTest
//
//  Created by MOHAMMED ABDUL BASITHK on 18/08/22.
//

import UIKit
import CoreData
import Kingfisher

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //outlet connections
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var manageObjectContext: NSManagedObjectContext!
    var employeeArray : [Employee] = []
    
    //viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    //viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCoreData()
    }
    
    //called at first time of app lounge only
    private func fetchCoreData() {
        self.updateData()
        if self.employeeArray.count == 0 {
            // if no data, then calls api to get data
            getData()
        }
    }
    
    //getting data from coredata to show in table
    //using same method to search filter nor normal tech with condition
    private func updateData(text : String = ""){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.manageObjectContext!)
        fetchRequest.entity = entity
        if text.count != 0{
            //fiter with name or email
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@ || email CONTAINS[cd] %@ ", text, text)
        }
        self.employeeArray = try! self.manageObjectContext!.fetch(fetchRequest) as! [Employee]
        tableView.reloadData()
    }
    
    //searchbar delegate methid
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateData(text: searchText.lowercased())
    }
    
    //getting data from api call and saving to core data
    private func getData() {
        let serviceObj = ServiceConnection()
        serviceObj.getEmployees { array in
            for item in array{
                let entity = NSEntityDescription.entity(forEntityName: "Employee", in: self.manageObjectContext!)
                let employee = Employee(entity: entity!, insertInto: self.manageObjectContext!)
                employee.id = Int16(item.id)
                employee.name = item.name
                employee.username = item.username
                employee.email = item.email
                employee.profile_image = item.profileImage
                employee.street = item.address.street
                employee.suite = item.address.suite
                employee.city = item.address.city
                employee.zipcode = item.address.zipcode
                employee.lat = item.address.geo.lat
                employee.lng = item.address.geo.lng
                employee.phone = item.phone
                employee.website = item.website
                employee.companyname = item.company?.name
                employee.catchPhrase = item.company?.catchPhrase
                employee.bs = item.company?.bs
                do{
                    try self.manageObjectContext!.save()
                }catch{
                    print("Data saving error", error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.updateData()
                }
            }
        }
    }
    
    //tableview delegate and data cource methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as! EmployeeCell
        cell.label1.text = employeeArray[indexPath.row].name
        cell.label2.text = employeeArray[indexPath.row].companyname ?? "No CompanyName"
        cell.profileImage.contentMode = .scaleAspectFill
        cell.profileImage.layer.cornerRadius = 25
        cell.profileImage.kf.setImage(with: URL(string: employeeArray[indexPath.row].profile_image ?? "https://www.kindpng.com/picc/m/134-1341850_contacts-icon-transparent-iphone-contact-icon-hd-png.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeDetailController") as! EmployeeDetailController
        vc.employee = employeeArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//home page tableview cell
class EmployeeCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
