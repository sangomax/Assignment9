//
//  AddEditTableViewCell.swift
//  Assignment6
//
//  Created by Adriano Gaiotto de Oliveira on 2021-01-10.
//

import UIKit

class AddEditTextFieldTableViewCell: UITableViewCell {
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "ChalkboardSE-Light",size: 16)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        textField.matchParent(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
