//
//  EmployeeDetailController.swift
//  BasithMachineTest
//
//  Created by MOHAMMED ABDUL BASITHK on 18/08/22.
//

import UIKit
import CoreData
import Kingfisher

class EmployeeDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //employee object will be send from prevous view controller
    var employee: Employee!
    
    //using array of touple to store 2 values
    var array : [(String,String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding data to array as touple for showing in tableview
        array.append(("Name",employee.name ?? ""))
        array.append(("UserName",employee.username ?? ""))
        array.append(("Email",employee.email ?? ""))
        array.append(("Address", "\(employee.street ?? ""), \(employee.suite ?? ""), \(employee.city ?? ""), \(employee.zipcode ?? "")"))
        array.append(("Phone",employee.phone ?? ""))
        array.append(("WebSite",employee.website ?? ""))
        array.append(("Company", "\(employee.companyname ?? ""), \(employee.catchPhrase ?? ""), \(employee.bs ?? "")"))
    }
    
    
    //table view delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.img.layer.cornerRadius = 75
            cell.img.kf.setImage(with: URL(string: employee.profile_image ?? "https://www.kindpng.com/picc/m/134-1341850_contacts-icon-transparent-iphone-contact-icon-hd-png.png"))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell") as! SecondCell
            cell.lbl1.text = array[indexPath.row-1].0
            cell.lbl2.text = array[indexPath.row-1].1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180
        }else{
            return UITableView.automaticDimension
        }
    }
}



//Table cells
class ImageCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SecondCell: UITableViewCell {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
