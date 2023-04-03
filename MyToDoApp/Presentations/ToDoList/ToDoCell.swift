//
//  ToDoCell.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/17.
//

import UIKit

protocol ToDoListCellDelegate {
    func push(data: ToDoData?)
}

final class ToDoCell: UITableViewCell, UITableViewCellRegister {
    
    static var cellId = "ToDoCell"
    static var isFromNib = false
    
    var delegate: ToDoListCellDelegate?
    var toDoData: ToDoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    private lazy var toDoTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        return label
    }()
    
    private lazy var dateTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(systemName: "pencil.tip"), for: .normal)
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 9)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(dateTextLabel)
        view.addSubview(updateButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toDoTextLabel, containerView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.addSubview(stackView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }
    
    
    
}


private extension ToDoCell {
    @objc func updateButtonTapped(_ sender: UIButton) {
        delegate?.push(data: toDoData)
    }
    
    func configureUI() {
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }
    
    func configureUIwithData() {
        toDoTextLabel.text = toDoData?.memoText
        dateTextLabel.text = toDoData?.dateString
        guard let colorNum = toDoData?.color else { return }
        let color = MyColor(rawValue: colorNum) ?? .red
        updateButton.backgroundColor = color.buttonColor
        bgView.backgroundColor = color.backgoundColor
    }

    
    func layout() {
        contentView.addSubview(bgView)
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            bgView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            bgView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            bgView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        
            stackView.leadingAnchor.constraint(equalTo: self.bgView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.bgView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.bgView.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bgView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        
            toDoTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
        
            containerView.heightAnchor.constraint(equalToConstant: 30),
            dateTextLabel.leadingAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.leadingAnchor),
            dateTextLabel.bottomAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.bottomAnchor),
            updateButton.trailingAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.trailingAnchor),
            updateButton.bottomAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.bottomAnchor),
            updateButton.widthAnchor.constraint(equalToConstant: 70),
            updateButton.heightAnchor.constraint(equalToConstant: 26)
        ])

    }

    
}
