//
//  UICellRegister.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/17.
//

import UIKit

protocol UITableViewCellRegister {
    
    static var cellId: String { get }
    static var isFromNib: Bool { get }
    
    static func register(tableView: UITableView)
    static func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath?) -> Self
    
}

extension UITableViewCellRegister where Self: UITableViewCell {
    static func register(tableView: UITableView) {
        if self.isFromNib {
            tableView.register(UINib(nibName: self.cellId, bundle: nil), forCellReuseIdentifier: self.cellId)
        } else {
            tableView.register(Self.self, forCellReuseIdentifier: self.cellId)
        }
    }
    
    static func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath?) -> Self {
        var cell: UITableViewCell?
        if let indexPath = indexPath {
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellId)
        }
        
        guard let cell = cell as? Self else { fatalError("Error! \(self.cellId)") }
        return cell
    }
}


